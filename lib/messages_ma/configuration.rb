require 'singleton'
module Carrier
  class Configuration

    autoload_modules :Models, :UI, :User
   
    include Singleton

    [:models, :user].each do |component|
      define_method component do
        conf_class(component).instance
      end
    end

    def conf_class component
      "#{conf}::#{component.to_s.camelize}".constantize
    end

    def ui
      conf::UI.instance
    end

    def conf
      Carrier::Configuration
    end

    def root
      File.expand_path("../../..", __FILE__)
    end
  end
end
