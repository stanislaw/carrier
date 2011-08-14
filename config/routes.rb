MessagesMa::Engine.routes.draw do

  resources :messages do
    member do
      get :as_sent, :reply
      get :expanded, :collapsed
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

end
