module Carrier
  module Rails
    module Helpers

      def self.included base
        base.send :helper_method, :unread_messages, :all_messages
        base.send :helper_method, :current_user
        base.send :helper_method, :prefix_for_messages
        base.send :helper_method, :find_method_for_user
      end

      def find_method_for_user
        :"find_by_#{user_key_attr}"
      end

      def user_key_attr
        carrier_config.user.key_attr
      end

      def prefix_for_messages
        carrier_config.routes.prefix_for_messages 
      end

      def current_user
        raise "Define #current_user method!" if !defined?(super)
        super
      end

      def all_messages
        @all_messages ||= Carrier::Message.for_or_by(current_user)
      end

      def unread_messages
        @unread_messages ||= Carrier::Message.unread(current_user)
      end

      private

      def carrier_config
        Carrier.config
      end
    end
  end
end
