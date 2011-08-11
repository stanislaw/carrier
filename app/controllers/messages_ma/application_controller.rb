module MessagesMa
  class ApplicationController < ActionController::Base
    helper_method :current_user
    before_filter { prepare_unread if user_signed_in? }
    before_filter :define_ui 
    
    def define_ui
      @ui = :rich 
      #@ui = :simple
    end

    def user_signed_in?
      current_user 
    end

    def current_user
      User.first || User.create(:username => "stanislaw")
    end
   
    private 

    def prepare_unread
      @_messages = Message.with_messages_for(current_user).unread_by(current_user)
      @messages_unread = @_messages.size
      return nil if @messages_unread==0
      @messages_unread
    end

  end
end
