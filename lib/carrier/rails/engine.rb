module Carrier
  
  def self.requires
    require_all File.join(::Carrier.config.root, 'app/validators')
    require_all File.join(::Rails.root, 'app/models')
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
    isolate_namespace Carrier

    initializer "carrier" do
      Carrier.requires
      Carrier.include_helpers
      Carrier.bootstrap_unread
    end

    config.to_prepare do
    end
  end
end
