$:.unshift File.dirname(__FILE__)
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)
require 'require_all'
require 'rspec/rails'
require 'cutter'
require 'capybara/rails'
require 'capybara/rspec'
require 'shoulda'
require 'factory_girl'

require_all File.expand_path('../support', __FILE__)

#ActiveRecord::Base.logger = Logger.new(STDERR)
def load_seeds
  load File.join(Rails.root, "db/seeds.rb")
end


class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|
  config.include Warden::Test::Helpers, :type => :request
  config.after(:each, :type => :request) {Warden.test_reset!}

  config.mock_with :rspec
  
  config.include Factory::Syntax::Methods

  config.use_transactional_fixtures = true

  config.before(:suite) do
    with ActiveRecord::Base.connection do
      tables.map do |table|
        drop_table table
      end
    end

    with ActiveRecord::Migrator do
      migrate File.expand_path('../dummy/db/migrate', __FILE__)
    end
  end

  config.before(:each) do
    tables_to_truncate = %w|messages chains users|

    with ActiveRecord::Base.connection do
      (tables & tables_to_truncate).map do |table|
        #execute "TRUNCATE #{table}"
      end
    end

  end

end

