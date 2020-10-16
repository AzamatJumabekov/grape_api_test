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
      error!({ error: 'Post not found or post_id parameter is missing' }, 404) && return unless post

      result = ::Ratings::Create.new(declared(params)).call
      if result.success?
        { average_rating: result.average }
      else
        error!({ error: result.error }, 422)
      end
    end
  end
end
