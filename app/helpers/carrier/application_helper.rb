module Carrier
  module ApplicationHelper
    def error_messages_for(resource)
      if resource.errors.any?
        render :partial => "partials/error_messages_for", :locals => {:resource => resource}
      end
    end

    def archived? message
      return if !message || message.new_record?
      message.archived_for?(current_user) 
    end

    def b string
      raw "<b>%s</b>" % string
    end

    # Extract this query somewhere... 
    def without_current_user_select
      User.select('id, username').where(User.arel_table[:id].not_in(current_user.id)).collect {|user| [user.username, user.id] }
    end
  end
end
