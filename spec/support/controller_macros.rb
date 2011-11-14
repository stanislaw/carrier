module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = :user
      sign_in Factory(:user) #@admin
    end
  end

end

