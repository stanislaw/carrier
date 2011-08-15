puts "loading seeds"
User.delete_all
['stanislaw', 'marixa', 'kristian', 'miloviza'].each do |name|
  User.create!(
    :username => name, 
    :email => "#{name}@gmail.com", 
    :password => "666666",
    :password_confirmation => "666666"
  )
end
