Rails.application.routes.draw do

  get "default/index"

  devise_for :users
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new'
  end

  mount Carrier::Engine => "/carrier" 

  root :to => "default#index"
end
