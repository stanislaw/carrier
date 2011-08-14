Rails.application.routes.draw do

  resources :posts

  mount MessagesMa::Engine => "/messages_ma" 
end
