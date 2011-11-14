module Carrier
  module Rails
    module Helpers

      def self.included base
        base.send :helper_method, :unread_messages, :all_messages
        base.send :helper_method, :current_user
        base.send :helper_method, :carrier_ui
      end

      def carrier_ui
        Carrier.config.ui.style
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

    end
  end
end
