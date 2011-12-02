module Carrier
  
  def self.carrier_requires
    validators = Dir[File.join ::Carrier.config.root, "app/validators/**/*.rb"]
    models = Dir[File.join ::Carrier.config.root, "app/models/**/*.rb"]
    
    (validators + models).each do |rb_file|
      require_dependency rb_file
    end
  end

  def self.models_requires
    app_models = Dir[File.join ::Rails.root, "app/models/**/*.rb"]

    (app_models).each do |rb_file|
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

  def self.check_unread!
    Carrier.config.check_unread!
  end
end

module Carrier
  class Engine < Rails::Engine
    engine_name :carrier
    isolate_namespace Carrier

    initializer "carrier" do
      #Carrier.models_requires
    end

    config.to_prepare do
      Carrier.carrier_requires
      # Carrier.models_requires
      # Carrier.check_unread!
      Carrier.include_helpers
      # Carrier.carrier_requires
    end
  end
end
