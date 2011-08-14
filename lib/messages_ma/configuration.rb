require 'singleton'
module MessagesMa
  class Configuration

    autoload_modules :UI
   
    include Singleton

    def ui
      UI.instance
    end
  end
end
