module Ratings
  class Create
    attr_reader :average, :error

    def initialize(params)
      @params = params
      @error = nil
    end

    def call
      @rating = Rating.create(@params)

      if @rating.errors.any?
        @error = @rating.errors.full_messages
      else
        @average = calculate_average_rating
        update_post_average_rating
      end

      self
    end

    def success?
      @error.nil?
    end

    private

    def calculate_average_rating
      query = "SELECT AVG(value)::numeric(10,2) FROM ratings WHERE ratings.post_id = #{@rating.post_id}"
      ActiveRecord::Base.connection.execute(query).values[0][0]
    end

    def update_post_average_rating
      @rating.post.update(average_rating: @average)
    end
  end
end
