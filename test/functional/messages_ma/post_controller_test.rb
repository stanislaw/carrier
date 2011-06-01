require 'test_helper'

module MessagesMa
  class PostControllerTest < ActionController::TestCase
    test "should get say" do
      get :say
      assert_response :success
    end
  
  end
end
