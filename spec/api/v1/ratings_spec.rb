require_relative '../../grape_helper'

describe '/api/v1/ratings', type: :request do
  let(:post_example) { create(:post) }
  let(:params) do
    {
      value: rand(1..5),
      post_id: post_example.id
    }
  end

  context 'succeeds' do
    describe 'POST' do
      it 'POST' do
        post '/api/v1/ratings', params
        expect(last_response.status).to eq(201)
        expect(response_json.key?('average_rating')).to be_truthy
        expect(response_json['average_rating']).to eq(post_example.reload.average_rating)
      end
    end
  end

  context 'fails' do
    describe 'POST with out of range value' do
      let(:params) do
        { value: 6, post_id: post_example.id }
      end
      let(:expected) { {"error"=>"value does not have a valid value"} }

      it 'POST' do
        post '/api/v1/ratings', params
        expect(JSON.parse(last_response.body)).to eq(expected)
      end
    end

    describe 'POST with out of range value' do
      let(:params) do
        { value: rand(1..5), post_id: post_example.id + 1 }
      end
      let(:expected) { {"error"=>"Post not found or post_id parameter is missing"} }

      it 'POST' do
        post '/api/v1/ratings', params
        expect(JSON.parse(last_response.body)).to eq(expected)
      end
    end
  end
end
