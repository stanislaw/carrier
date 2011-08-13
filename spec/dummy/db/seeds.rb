puts "loading seeds"
User.delete_all
User.create(:username => "stanislaw")
User.create(:username => "marixa")
User.create(:username => "miloviza")
User.create(:username => "lordvader")
User.create(:username => "lucky")
User.create(:username => "valentine")
