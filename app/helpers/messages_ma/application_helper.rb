module MessagesMa
  module ApplicationHelper
    def error_messages_for(resource)
      if resource.errors.any?
        render :partial => "partials/error_messages_for", :locals => {:resource => resource}
      end
    end

    def archived? message
      return false if !message || message.new_record?
      message.archived_for? current_user
    end

    def b string
      raw "<b>%s</b>" % string
    end
  end
end
