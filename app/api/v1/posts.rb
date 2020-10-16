module V1
  class Posts < Grape::API
    get '/' do
      raw_query = <<-QUERY
        select title, content
        from posts
        order by case when average_rating is null then 1 else 0 end, average_rating desc
        limit ?
      QUERY
      query = ActiveRecord::Base.sanitize_sql([raw_query, params[:per_page] || 200])
      ActiveRecord::Base.connection.execute(query)
    end

    params do
      requires :title, type: String
      requires :content, type: String
      requires :ip, type: String
    end

    post '/' do
      user = User.find_or_create_by(login: params.delete(:author))
      error!({ error: user.errors.full_messages }, 404) && return if user.errors.any?

      result = user.posts.create(declared(params))
      if result.errors.any?
        error!({ error: result.errors.full_messages }, 422)
      else
        status 201
      end
    end
  end
end
