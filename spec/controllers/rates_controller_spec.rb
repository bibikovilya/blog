describe RatesController do
  describe 'POST create' do
    let(:cur_post) { create :post }

    context 'success' do
      before do
        post :create, params: { post_id: cur_post.id, mark: 5 }
      end

      it 'should returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'should response with post average rate' do
        expect(response.body).to eq '5.0'
      end
    end

    context 'fail' do
      before do
        post :create, params: { post_id: 0, mark: 0 }
      end

      it 'should returns http error' do
        expect(response).to have_http_status(422)
      end

      it 'should returns errors list' do
        expect(response.body).to look_like_json
        expect(body_as_json).to include({ errors: ['Post must be present',
                                                   'Mark must be from 1 to 5'] })
      end
    end
  end
end
