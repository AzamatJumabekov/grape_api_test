require 'net/http'

class Request
  URL = 'http://localhost:9292'.freeze

  def initialize(endpoint, params)
    @endpoint = endpoint
    @params = params
  end

  def call
    uri = URI(URL + @endpoint)
    res = Net::HTTP.post_form(uri, @params)
  end
end
