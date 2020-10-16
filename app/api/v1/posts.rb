module V1
  class Posts < Grape::API
    get '/' do
      raw_query = <<-SQL
        select title, content
        from posts
        order by case when average_rating is null then 1 else 0 end, average_rating desc
        limit ?
      SQL
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

    get '/list_of_ips' do
      query = <<-SQL
        SELECT
          ip,
          json_agg(users.login)
        FROM posts as p
        INNER JOIN users on users.id = p.user_id
        GROUP BY p.ip
        HAVING (count(users.id) >= 2)
        ORDER BY p.ip asc;
      SQL

      result = ActiveRecord::Base.connection.execute(query)
      result.values.map do |ip, logins|
        { ip => JSON[logins] }
      end
    end
  end
end
