ENV['RACK_ENV'] ||= 'test'

require_relative '../application'
require "rack/test"
require 'factory_bot'
require 'database_cleaner'
require 'pry'

Dir[ROOT_PATH.join('spec/support/**/*.rb')].sort.each { |f| require f }

def app
  Application
end

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.include ResponseHelper

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
