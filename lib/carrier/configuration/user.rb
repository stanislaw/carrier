require 'singleton'

module Carrier
  class Configuration
    class User
      include Singleton

      attr_writer :key_attr

      def key_attr
        @key_attr || default_key_attr
      end

      def default_key_attr
        :id
      end

      def reset_to_defaults!
        @key_attr = nil
      end
    end # module User 
  end # class Configuration
end # module Carrier

