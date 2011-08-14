module MessagesMa
  module Rails
    module ControllerHelpers

      def self.included base
        base.send :helper_method, :unread_messages, :current_user
        base.send :before_filter, :define_ui
      end

      private 

      def define_ui
        @ui = MessagesMa.config.ui.style
      end

      def current_user
        raise "Define #current_user method!"
      end

      def unread_messages
        @unread_messages ||= Message.unread(current_user)
      end

    end
  end
end
