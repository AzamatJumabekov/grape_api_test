require_relative '../../grape_helper'

describe '/api/v1/posts/list_of_ips', type: :request do
  let(:post_example) { create(:post) }
  let(:ips) { Array.new(2) {|i| "255.255.255.#{i}" } }
  let(:users) { create_list(:user, 5) }

  context 'success' do
    let!(:posts) do
      Array.new(20) { create(:post, ip: ips.sample, user: users.sample) }
    end
    describe 'GET' do
      it do
        get '/api/v1/posts/list_of_ips'
        expect(response_json.length).to eq(ips.length)
        expect(response_json.first.keys).to eq(['ip', 'authors'])
        expect(response_json.map {|i| i['ip']}).to eq(ips)
      end
    end

    describe 'GET returns if users count more than 1' do
      let(:ip) { '255.255.255.255' }
      let(:user) { create(:user) }
      let!(:post1) { create(:post) }
      let(:posts) { create_list(:post, 2, ip: ip, user: user) }
      let(:response_ips) { response_json.map {|i| i['ip']} }
      it do
        get '/api/v1/posts/list_of_ips'
        expect(response_json.length).to eq(1)
        expect(response_ips.length).to eq(1)
        expect(response_ips).to include(ip)
        expect(response_json.first['authors'].length).to eq(1)
        expect(response_json.first['authors']).to include(user.login)
      end
    end
  end

  context 'empty result' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }

    describe 'GET' do
      it do
        get '/api/v1/posts/list_of_ips'
        expect(response_json).to eq([])
      end
    end
  end
end
