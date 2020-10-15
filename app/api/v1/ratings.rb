module V1
  class Ratings < Grape::API
    get '/' do
      Rating.all
    end

    params do
      requires :value, type: Integer, values: [*1..5]
      requires :post_id, type: Integer
    end

    post '/' do
      post = Post.find_by(id: params[:post_id])
      error!({ messages: ['Post not found'] }, 404) && return unless post

      result = Rating.create(declared(params))
      if result
        status 201
      else
        error!({ messages: result.errors.full_messages }, 422)
      end
    end
  end
end
