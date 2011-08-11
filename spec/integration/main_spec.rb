require 'dummy_spec_helper'

describe "" do
  it "truth" do
    Rails.application.should be_kind_of(Dummy::Application)
  end

  it "should get root page" do
    get 'messages_ma/messages'
    response.status.should be(200)
  end

  it "should" do
    pending
  end
end
