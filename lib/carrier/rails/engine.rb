module Carrier
  
  def self.requires
    validators = Dir[File.join ::Carrier.config.root, "app/validators/**/*.rb"]
    models = Dir[File.join ::Carrier.config.root, "app/models/**/*.rb"]

    app_models = Dir[File.join ::Rails.root, "app/models/**/*.rb"]

    (validators + models + app_models).each do |rb_file|
      require_dependency rb_file
    end
  end
  
  def self.include_helpers
    ActiveSupport.on_load(:action_controller) do
      include Carrier::Rails::Helpers
    end

    ActiveSupport.on_load(:action_view) do
    end
  end

  def self.bootstrap_unread
    ActiveSupport.on_load(:after_initialize) do
      ActiveSupport.on_load(:active_record) do
        Carrier.config.user.bootstrap_unread! descendants
      end
    end
  end
end

module Carrier
  class Engine < Rails::Engine
    engine_name :carrier
    isolate_namespace Carrier

    initializer "carrier" do
      Carrier.requires
    end

    config.to_prepare do
      Carrier.requires
      Carrier.bootstrap_unread
      Carrier.include_helpers
    end
  end
end
