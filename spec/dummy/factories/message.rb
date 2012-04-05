FactoryGirl.define do
  factory :message, :class => Carrier::Message do
    sender_user { |su| singleton(:user) }
    recipients { |r| [ singleton(:second_user).id ] } 

    content "content of test message"
    subject "subject of test message"
  end
end
