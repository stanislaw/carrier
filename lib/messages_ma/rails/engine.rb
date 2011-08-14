module MessagesMa
  def self.include_helpers
    ActiveSupport.on_load(:action_controller) do

      include MessagesMa::Rails::ControllerHelpers
    end

    ActiveSupport.on_load(:action_view) do
      #include MessagesMa::Rails::ViewHelpers
    end
  end

end

module MessagesMa
  class Engine < Rails::Engine
    isolate_namespace MessagesMa

    initializer "messages_ma.helpers" do
      MessagesMa.include_helpers
    end
  end
end
