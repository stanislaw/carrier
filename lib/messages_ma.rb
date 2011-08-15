require "carrier/rails/engine" if defined?(Rails)

require 'sugar-high/array'
require 'sugar-high/class_ext'

module Carrier
  autoload_modules :Configuration, :Rails

  class << self
    def config &block
      conf = Carrier::Configuration.instance
      yield conf if block
      conf
    end

    alias_method :configure, :config
  end
end
