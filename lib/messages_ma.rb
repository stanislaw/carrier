require "messages_ma/rails/engine" if defined?(Rails)

require 'sugar-high/array'
require 'sugar-high/class_ext'

module MessagesMa
  autoload_modules :Configuration, :Rails

  class << self
    def config &block
      conf = MessagesMa::Configuration.instance
      yield conf if block
      conf
    end

    alias_method :configure, :config
  end
end
