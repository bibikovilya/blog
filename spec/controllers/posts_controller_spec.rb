describe PostsController do
  describe 'POST create' do
    context 'success' do
      let(:title) { 'New post' }
      let(:body) { 'Post content' }
      let(:login) { 'user_login' }
      let(:ip) { '128.0.0.1' }

      before do
        post :create, params: { title: title, body: body, login: login, ip: ip }
      end

      it 'should returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'should response with Post attributes' do
        expect(response.body).to look_like_json
        expect(body_as_json).to include({ title: 'New post', body: 'Post content', ip: '128.0.0.1' })
      end
    end

    context 'fail' do
      before do
        post :create
      end

      it 'should returns http error' do
        expect(response).to have_http_status(422)
      end

      it 'should returns errors list' do
        expect(response.body).to look_like_json
        expect(body_as_json).to include({ errors: ["Title can't be empty",
                                                   "Body can't be empty",
                                                   'IP address must be present',
                                                   'Login must be present'] })
      end
    end
  end
end
