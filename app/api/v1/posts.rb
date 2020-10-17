require_relative '../../../lib/grape/formatter/json'

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

    resource '/list_of_ips' do
      get '' do
        query = <<-SQL
          select json_agg(stst) AS json_array
          from(
              select ip, json_agg(users.login) as authors
              from (
                   select user_id, ip
                   from posts
                   group by ip, user_id
                   having count(user_id) > 1
              ) as p
              inner join users on p.user_id = users.id
              group by ip
              order by ip
          ) stst
        SQL

        ActiveRecord::Base.connection.execute(query).values[0][0] || []
      end
    end
  end
end
