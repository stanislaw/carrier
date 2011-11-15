puts "Dummy application => loading seeds"

User.delete_all
Carrier::Message.delete_all

['stanislaw', 'marixa', 'kristian', 'miloviza'].each do |name|
  User.create!(
    :username => name, 
    :email => "#{name}@gmail.com", 
    :password => "666666",
    :password_confirmation => "666666"
  )
end

first_user = User.find_by_username("stanislaw")
second_user = User.find_by_username("marixa")

first_message = Carrier::Message.create!(:sender => first_user.id, :recipients => [second_user.id], :subject => "first message", :content => "message#1")

second_message = Carrier::Message.new_answer(first_message.id, second_user)
second_message.content = "message#2"
second_message.save!

third_message = Carrier::Message.create!(:sender => first_user.id, :recipients => [second_user.id], :subject => "third message", :content => "message#3")

fourth_message = Carrier::Message.create!(:sender => second_user.id, :recipients => [first_user.id], :subject => "fourth message", :content => "message#4")
