module V1
  class Ratings < Grape::API
    get '/' do
      Rating.all
    end
  end
end
