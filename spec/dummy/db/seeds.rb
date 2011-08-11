puts "loading seeds"
User.delete_all
User.create(:username => "stanislaw")
User.create(:username => "marixa")
User.create(:username => "miloviza")
