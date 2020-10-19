require 'grape'
require 'grape-swagger'
require 'otr-activerecord'
require 'multi_json'
require 'multi_json/adapters/oj'
MultiJson.adapter = MultiJson::Adapters::Oj

ENV['RACK_ENV'] ||= 'development'
ROOT_PATH ||= Pathname.new(::File.expand_path('../../', __FILE__)).freeze
OTR::ActiveRecord.configure_from_file! "config/database.yml"

Dir["#{ROOT_PATH}/app/entities/**/*.rb"].each { |f| require f }
Dir["#{ROOT_PATH}/app/services/**/*.rb"].each { |f| require f }
Dir["#{ROOT_PATH}/app/api/**/*.rb"].each { |f| require f }
