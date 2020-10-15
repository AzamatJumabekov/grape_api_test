module Posts
  class Create
    def initialize(params)
      @params = params
      @author_params = { login: params.delete(:author) }
      @post_params = params
    end

    def call
      user = User.find_or_create_by(@author_params)
      user.posts.create(@post_params)
    end
  end
end
