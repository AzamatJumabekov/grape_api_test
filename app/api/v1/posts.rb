module V1
  class Posts < Grape::API
    get '/' do
      query = ActiveRecord::Base.sanitize_sql(["select id, title, content from posts limit ?",  params[:per_page] || 200])
      ActiveRecord::Base.connection.execute(query).values
    end

    params do
      requires :title, type: String
      requires :content, type: String
      requires :ip, type: String
      requires :author, type: String
    end

    post '/' do
      result = ::Posts::Create.new(declared(params)).call
      if result.errors.any?
        error!({ messages: result.errors.full_messages }, 422)
      else
        status 201
      end
    end
  end
end
