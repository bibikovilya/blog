describe PostServices::AddMark do
  describe '.call' do
    let(:post) { create :post }
    context 'success' do
      subject { PostServices::AddMark.new(post_id: post.id, mark: 5) }

      it 'should be success' do
        expect(subject.call).to be_truthy
      end

      it 'should create rate' do
        expect { subject.call }.to change { Rate.count }.by(1)
      end

      context 'rate' do
        it 'should change' do
          expect { subject.call }.to change { post.average_rate }
        end

        it 'should return average value' do
          create :rate, post: post, value: 1
          create :rate, post: post, value: 5
          create :rate, post: post, value: 3

          expect { subject.call }.to change { post.average_rate }.from(3).to(3.5)
        end

        context 'with many posts' do
          let(:post2) { create :post }
          let(:post3) { create :post }

          it 'should not change other rates' do
            expect { subject.call }.to_not change { post2.average_rate }
            expect { subject.call }.to_not change { post3.average_rate }
          end
        end
      end
    end

    context 'fail' do
      let(:post_error) { 'Post must be present' }
      let(:mark_error) { 'Mark must be from 1 to 5' }
      let(:all_errors) { [] << post_error << mark_error }

      subject { PostServices::AddMark }

      it 'with empty params' do
        expect(subject.new.call).to be_falsey
      end

      context 'with errors' do
        it 'of all' do
          service = subject.new
          service.call
          expect(service.errors).to eq all_errors
        end

        it 'post' do
          service = subject.new(mark: 5)
          service.call
          expect(service.errors).to eq [post_error]
        end

        it 'empty mark' do
          service = subject.new(post_id: post.id)
          service.call
          expect(service.errors).to eq [mark_error]
        end

        it 'wrong mark' do
          service = subject.new(post_id: post.id, mark: 99)
          service.call
          expect(service.errors).to eq [mark_error]
        end

        it 'string mark' do
          service = subject.new(post_id: post.id, mark: 'str')
          service.call
          expect(service.errors).to eq [mark_error]
        end
      end
    end
  end
end
