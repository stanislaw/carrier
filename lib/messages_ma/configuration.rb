require 'singleton'
module MessagesMa
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
      MessagesMa::Configuration
    end
  end
end
