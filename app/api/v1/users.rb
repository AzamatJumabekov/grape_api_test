module V1
  class Users < Grape::API
    get '/' do
      User.all
    end
  end
end
