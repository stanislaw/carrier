module MessagesMa
  module ApplicationHelper
    def error_messages_for(resource)
      if resource.errors.any?
        render :partial => "partials/error_messages_for", :locals => {:resource => resource}
      end
    end
  end
end
