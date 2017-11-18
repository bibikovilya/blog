describe PostServices::Top do
  describe '.call' do
    let(:post1) { create :post, title: 'Post#1', body: 'Body#1' }
    let(:post2) { create :post, title: 'Post#2', body: 'Body#2' }
    let(:post3) { create :post, title: 'Post#3', body: 'Body#3' }
    let!(:post4) { create :post, title: 'Post#4', body: 'Body#4' }

    before do
      create :rate, post: post1, value: 1
      create :rate, post: post1, value: 5
      create :rate, post: post1, value: 3
      create :rate, post: post2, value: 5
      create_list :rate, 2, post: post3, value: 5
      create_list :rate, 2, post: post3, value: 3
    end

    context 'success' do
      subject { PostServices::Top.new(3) }

      it 'should be success' do
        expect(subject.call).to be_truthy
      end

      it 'should return first N posts' do
        subject.call
        expect(subject.posts.count).to eq 3
      end

      it 'should return max rated posts' do
        subject.call
        expect(subject.posts.map { |p| p['id'] }).to include post1.id, post2.id, post3.id
      end

      it 'should order be rate' do
        subject.call
        expect(subject.posts[0]['id']).to eq post2.id
        expect(subject.posts[1]['id']).to eq post3.id
        expect(subject.posts[2]['id']).to eq post1.id
      end
    end

    context 'fail' do
      subject { PostServices::Top.new(-1) }

      it 'should be success' do
        expect(subject.call).to be_falsey
      end

      it 'should return error' do
        subject.call
        expect(subject.errors).to eq ['Top count should be a number']
      end
    end
  end
end
