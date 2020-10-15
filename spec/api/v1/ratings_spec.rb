require_relative '../../grape_helper'

describe '/api/v1' do
  describe '/ratings' do
    let(:post) { create(:post) }
    let(:params) do
      {
        value: rand(1..5),
        post_id: post.id
      }
    end

    it 'returns expected result' do
      post '/api/v1/ratings', params: params
      binding.pry
    end
  end
end
