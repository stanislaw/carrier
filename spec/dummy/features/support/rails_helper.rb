require 'sugar-high/dsl'

module RailsHelper
  def logger
    Rails.logger
  end
  
  def migrate_if_needed
    with ActiveRecord::Base.connection do
      with ActiveRecord::Migrator do 
        migration_path = File.expand_path("#{Rails.root}/db/migrate", __FILE__)
        migrate migration_path
      end if tables.empty?
    end
  end
  
  def truncate_tables
    with ActiveRecord::Base.connection do
      (tables - ['schema_migrations', 'roles']).map do |table|
        table_count = execute("SELECT COUNT(*) FROM #{table}").first.first
        execute "TRUNCATE #{table}" unless table_count == 0
      end
    end
  end

  def reload_files
    ['app/models', 'app/controllers', :lib].each do |folder|
      included_files = []
      Dir["#{Rails.root}/#{folder}/**/*.rb"].each do |f| 
        begin
          included_files << "#{f}"
          load f 
        rescue => e
          puts e.message
        end
        # puts "(Re)loaded files: " << included_files.inspect
      end
    end
  end

  def establish_connection
    db_config = YAML.load(File.read(File.join(Rails.root, 'config','database.yml')))[ENV['RAILS_ENV']]

    ActiveRecord::Base.establish_connection db_config
  end

  def drop_connection
    ActiveRecord::Base.remove_connection
  end
end
