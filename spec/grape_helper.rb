ENV['RACK_ENV'] ||= 'test'

require_relative '../application'
require "rack/test"
require 'factory_bot'
require 'database_cleaner'
require 'pry'

Dir[App.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

def app
  Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
