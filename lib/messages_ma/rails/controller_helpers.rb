module MessagesMa
  module Rails
    module ControllerHelpers

    def self.included base
      base.send :helper_method, :unread_messages, :current_user
      base.send :before_filter, :define_ui
    end

    def define_ui
      MessagesMa.config.ui.style
    end

    def current_user
      User.find(3) || User.create(:username => "stanislaw")
    end
   
    private 

    def unread_messages
      @unread_messages ||= Message.unread(current_user)
    end

    end
  end
end
