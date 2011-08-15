require 'singleton'
require 'sugar-high/class_ext'

module Carrier
  class Configuration
    class User
      include Singleton
      include ClassExt

      def models
        ["User"]
      end

      def classes
        models.map {|model| try_class model }
      end

      def bootstrap_unread! available_classes
        (classes & available_classes).map {|clazz| clazz.send(:acts_as_reader) }
      end
    end
  end
end
