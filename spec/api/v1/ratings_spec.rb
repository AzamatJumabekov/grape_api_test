require_relative '../../grape_helper'

describe '/api/v1', type: :request do
  describe '/ratings' do
    let(:post_example) { create(:post) }
    let(:params) do
      {
        value: rand(1..5),
        post_id: post_example.id
      }
    end

    context 'success' do
      it 'POST' do
        post '/api/v1/ratings', params
        expect(last_response.status).to eq(201)
      end
    end

    context 'fail' do
      
    end
  end
end
