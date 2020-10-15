require_relative 'config/boot'

module API
  class Root < Grape::API
    format :json

    mount ApiBase => '/api'
    add_swagger_documentation
  end
end

Application = Rack::Builder.new do
  map "/" do
    run API::Root
  end
end
