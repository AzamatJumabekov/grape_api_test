require_relative 'env'

class App
  APP_ENV = ENV.fetch('RACK_ENV', 'development').downcase.freeze

  def self.env
    Env.new(APP_ENV)
  end

  def self.configure
    yield config
  end

  def self.root
    ROOT_PATH
  end
end
