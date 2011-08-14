Rails.application.routes.draw do

  devise_for :users
  #devise_scope :user do
  #  get 'sign_in', :to => 'devise/sessions#new'
  #end

  resources :posts

  mount MessagesMa::Engine => "/messages_ma" 
end
