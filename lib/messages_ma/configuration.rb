require 'singleton'
module MessagesMa
  class Configuration

    autoload_modules :Models, :UI
   
    include Singleton

    def ui
      UI.instance
    end

    def models
      conf::Models.instance
    end

    def conf
      MessagesMa::Configuration
    end
  end
end
