describe PostServices::Create do
  describe '.call' do
    context 'success' do
      let(:params) { { title: 'New post',
                       body: 'Post content',
                       login: 'user_login',
                       ip: '128.0.0.1' }
      }
      subject { PostServices::Create.new(params) }

      it 'should be success' do
        expect(subject.call).to be_truthy
      end

      describe 'user' do
        it 'create new one' do
          expect { subject.call }.to change { User.count }.to(1)
        end

        it 'create new one with login' do
          subject.call
          expect(subject.post.user.login).to eq 'user_login'
        end

        it 'not create present user' do
          create :user, login: 'user_login'
          expect { subject.call }.to_not change { User.count }
        end
      end
    end

    context 'fail' do
      let(:title_error) { "Title can't be empty" }
      let(:body_error) { "Body can't be empty" }
      let(:ip_error) { 'IP address must be present' }
      let(:login_error) { 'Login must be present' }
      let(:ip_not_valid_error) { 'IP not valid' }
      let(:all_errors) { [] << title_error << body_error << ip_error << login_error }

      subject { PostServices::Create }

      it 'with empty params' do
        expect(subject.new.call).to be_falsey
      end

      context 'with error' do
        it 'of all' do
          service = subject.new
          service.call
          expect(service.errors).to eq all_errors
        end

        it 'title' do
          service = subject.new(body: 'Post body', ip: '128.0.0.1', login: 'user1')
          service.call
          expect(service.errors).to eq [title_error]
        end

        it 'body' do
          service = subject.new(title: 'TITLE', ip: '128.0.0.1', login: 'user1')
          service.call
          expect(service.errors).to eq [body_error]
        end

        it 'ip' do
          service = subject.new(body: 'Post body', title: 'Post title', login: 'user1')
          service.call
          expect(service.errors).to eq [ip_error]
        end

        it 'login' do
          service = subject.new(body: 'Post body', ip: '128.0.0.1', title: 'Post title')
          service.call
          expect(service.errors).to eq [login_error]
        end

        it 'wrong ip' do
          service = subject.new(body: 'Post body', ip: 'text', title: 'Post title', login: 'login')
          service.call
          expect(service.errors).to eq [ip_not_valid_error]
        end
      end
    end
  end
end
