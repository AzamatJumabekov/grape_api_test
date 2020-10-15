require_relative 'v1/users'
require_relative 'v1/posts'
require_relative 'v1/ratings'

class ApiBase < Grape::API
  mount V1::Users => '/v1/users'
  mount V1::Posts => '/v1/posts'
  mount V1::Ratings => '/v1/ratings'
end
