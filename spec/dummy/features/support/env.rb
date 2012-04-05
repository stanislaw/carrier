ENV['RAILS_ENV'] = 'test'

require 'require_all'
require 'cucumber/rails'
require 'factory_girl_rails'
require_all File.expand_path File.dirname __FILE__

require File.expand_path("../../../config/environment.rb",  __FILE__)

ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../spec/dummy"

ActionController::Base.allow_rescue = false

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Cucumber::Rails::World.use_transactional_fixtures = true

Cucumber::Rails::Database.javascript_strategy = :shared_connection

include Warden::Test::Helpers
include FactoryGirl::Syntax::Methods

include SingletonHelper

include RailsHelper

migrate_if_needed 
truncate_tables

Before do
  Transaction.start
  reset_singletons!
end

After do
  Transaction.clean
  Warden.test_reset!
end
