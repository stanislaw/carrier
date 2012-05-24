FactoryGirl.define do
  factory :user, :class => User do
    id 1
    email 'stanislaw@gmail.com'
    username 'stanislaw'
    password '666666'
  end

  factory :second_user, :class => User do
    id 2
    email 'miloviza@gmail.com'
    username 'miloviza'
    password '666666'
  end

  factory :third_user, :class => User do
    id 3
    email 'marixa@gmail.com'
    username 'marixa'
    password '666666'
  end
end
