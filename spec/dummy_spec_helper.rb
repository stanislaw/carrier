$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'require_all'
require 'rspec/rails'
require 'database_cleaner'
require 'cutter'
require 'capybara/rails'
require 'capybara/rspec'
#require 'cantango/rspec'
#require 'factory_girl'
#require 'mocha'
#require 'factories'
#require 'controller_macros'
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

#ActiveRecord::Base.logger = Logger.new(STDERR)

def migration_folder(name)
  migrations_path = File.dirname(__FILE__)
  name ? File.join("#{migrations_path}" "#{name}") : "#{migrations_path}/migrations"
end

def migrate(name = nil)
  mig_folder = migration_folder(name)
  ActiveRecord::Migrator.migrate mig_folder
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:suite) do
    ActiveRecord::Base.connection.tables.map do |table|
      ActiveRecord::Base.connection.drop_table table
    end

    migrate("/dummy/db/migrate")
    require "dummy/db/seeds"
  end
end

