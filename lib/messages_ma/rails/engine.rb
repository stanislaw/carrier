require 'require_all'

module MessagesMa
  def self.include_helpers
    ActiveSupport.on_load(:action_controller) do
      include MessagesMa::Rails::Helpers
    end

    ActiveSupport.on_load(:action_view) do
    end
  end

  def self.bootstrap_unread
    require_all File.join(::Rails.root, 'app/models')
    ActiveSupport.on_load(:after_initialize) do
      ActiveSupport.on_load(:active_record) do
        p descendants
        MessagesMa.config.user.bootstrap_unread! descendants
      end
    end
  end
end

module MessagesMa
  class Engine < Rails::Engine
    isolate_namespace MessagesMa

    initializer "messages_ma.helpers" do
      MessagesMa.include_helpers
      MessagesMa.bootstrap_unread
    end

    config.to_prepare do
    end
  end
end
