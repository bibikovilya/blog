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

  describe 'GET top' do
    context 'success' do
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

      before do
        get :top, params: { count: 3 }
      end

      it 'should returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'should response top posts' do
        expect(response.body).to look_like_json
        expect(body_array_as_json).to include({ id: post2.id,
                                                title: 'Post#2',
                                                body: 'Body#2',
                                                rate: '5' })
        expect(body_array_as_json).to include({ id: post3.id,
                                                title: 'Post#3',
                                                body: 'Body#3',
                                                rate: '4' })
        expect(body_array_as_json).to include({ id: post1.id,
                                                title: 'Post#1',
                                                body: 'Body#1',
                                                rate: '3' })
      end
    end

    context 'fail' do
      before do
        get :top, params: { count: -1 }
      end

      it 'should returns http error' do
        expect(response).to have_http_status(422)
      end

      it 'should returns errors list' do
        expect(response.body).to look_like_json
        expect(body_as_json).to include({ errors: ['Top count should be a number'] })
      end
    end
  end
end
