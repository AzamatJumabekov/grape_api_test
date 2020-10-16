module ResponseHelper
  def response_json
    JSON.parse(last_response.body)
  rescue StandardError
    {}
  end
end
