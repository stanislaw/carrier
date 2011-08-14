module MessagesMa
  class ApplicationController < ActionController::Base
    def current_user
      User.find(3) || User.create(:username => "stanislaw")
    end
  end
end
