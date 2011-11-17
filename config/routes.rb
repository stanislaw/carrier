# Prefix for messages. Defaults to '/messages' resulting in 
# /messages, /messages/1, /messages/sent, /messages/archived 

prefix_for_messages = Carrier.config.routes.prefix_for_messages

Carrier::Engine.routes.draw do

  resources :messages, :path => prefix_for_messages do
    member do
      get :as_sent 
      get :reply
      get :expanded
      get :collapsed
    end
    collection do
      get :sent
      get :archive
    end
  end

  resources :chains do 
    member do
      post :archive
      post :unarchive
    end
  end

  root :to => "messages#index"
end
