module V1
  class Users < Grape::API
    get '/' do
      User.all
    end

    params do
      requires :login, type: String
    end

    post '' do
      result = User.create(declared(params))
      if result
        status 201
      else
        error!({ messages: result.errors.full_messages }, 422)
      end
    end
  end
end
