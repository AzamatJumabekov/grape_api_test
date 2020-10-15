require_relative '../../grape_helper'

describe '/api/v1' do
  describe '/users' do
    let!(:users) { create_list(:user, 5) }
    let(:expected) { users.as_json }

    it 'returns expected result' do
      get '/api/v1/users'
      result = JSON.parse(last_response.body)
      expect(result).to eq(expected)
    end
  end
end
