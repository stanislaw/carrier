module MessagesMa
  class ApplicationController < ActionController::Base
    before_filter :authenticate_user!
  end
end
