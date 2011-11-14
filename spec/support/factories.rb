FactoryGirl.define do
  factory :first_message, :class => Carrier::Message do
    association :sender_user, :factory => :user
    recipients [2, 3]
    content "Hello!"
    subject "FirstMessage"
    association :chain, :factory => :chain
  end

  factory :second_message, :class => Carrier::Message do
    association :sender_user, :factory => :user_second
    recipients [3, 1]
    content "Hello you too!"
    subject "SecondMessage"
    association :chain, :factory => :chain
  end

  factory :user do
    username "stanisla"
    email "stanisla@gmail.com"
    password "666666"
    password_confirmation "666666"
  end

  factory :user_second, :class => User do
    username "marixa"
    email "marixa@gmail.com"
    password "666666"
    password_confirmation "666666"
  end

  factory :chain, :class => Carrier::Chain do
  end
end

