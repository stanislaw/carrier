FactoryGirl.define do
  factory :message, :class => Carrier::Message do
    sender { singleton(:user).id }
    recipients { [ singleton(:second_user).id, singleton(:third_user).id ] }
    content "content of test message"
    subject "subject of test message"
  end

  factory :second_message, :class => Carrier::Message do
    sender_user { |su| singleton(:second_user) }
    recipients { |r| [ singleton(:user).id ] } 

    content "content of test message"
    subject "subject of test message"
  end 
  
  factory :third_message, :class => Carrier::Message do
    sender_user { |su| singleton(:user) }
    recipients { |r| [ singleton(:second_user).id ] } 

    content "content of test message"
    subject "subject of test message"
  end
end
