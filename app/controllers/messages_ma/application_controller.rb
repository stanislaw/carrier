module MessagesMa
  class ApplicationController < ActionController::Base
    helper_method :current_user
    def current_user
      logger.info("123\n\n\n\n")
      current_user = User.find(1)
    end
  end
end
