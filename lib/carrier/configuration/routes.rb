require 'singleton'
module Carrier
  class Configuration
    class Routes
      include Singleton

      attr_writer :prefix_for_messages

      def prefix_for_messages
        @prefix_for_messages || "/messages"
      end

      def reset_to_defaults!
        @prefix_for_messages = nil
      end
    end # module Routes
  end # class Configuration
end # module Carrier

