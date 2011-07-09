class ApplicationController < ActionController::Base
  protect_from_forgery
 
  def current_user
    logger.info("dummy application controller \n\n\n")
  end
end
