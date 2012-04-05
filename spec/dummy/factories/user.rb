FactoryGirl.define do
  factory :user do
    email 'stanislaw@gmail.com'
    username 'stanislaw'
    password '666666'
  end

  factory :second_user, :class => User do
    email 'miloviza@gmail.com'
    username 'milovila'
    password '666666'
  end
end
