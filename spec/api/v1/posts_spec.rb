require_relative '../../grape_helper'

describe '/api/v1/posts', type: :request do
  let(:post_example) { create(:post) }
  let(:author) { attributes_for(:user)[:login] }
  let(:params) { attributes_for(:post, author: author) }
  let(:expected_user) { User.last }
  let(:created_post) { Post.last }

  context 'succeeds' do
    describe 'POST with non existing user' do
      it 'creates user' do
        post '/api/v1/posts', params
        expect(last_response.status).to eq(201)
        expect(created_post.user).to eq(expected_user)
        expect(created_post.title).to eq(params[:title])
      end
    end

    describe 'POST with existing user' do
      let(:user) { create(:user) }
      let(:author) { user.login }

      it do
        post '/api/v1/posts', params
        expect(last_response.status).to eq(201)
        expect(created_post.user).to eq(user)
        expect(created_post.title).to eq(params[:title])
        expect(created_post.ip).to eq(params[:ip])
      end
    end
  end

  context 'fails' do
    describe 'POST without author provided' do
      let(:author) { nil }
      let(:expected) { {"error"=>["Login can't be blank"]} }

      it 'POST' do
        post '/api/v1/posts', params
        expect(JSON.parse(last_response.body)).to eq(expected)
      end
    end

    %i[title content ip].each do |param|
      describe "POST with missing #{param}" do
        let(:expected) { {"error"=>["#{param.capitalize} can't be blank"]} }
        before do
          params.delete(param)
        end

        it do
          post '/api/v1/posts', params
          expect(last_response.status).to eq(422)
          expect(JSON.parse(last_response.body)).to eq(expected)
        end
      end
    end
  end
end
