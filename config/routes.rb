MessagesMa::Engine.routes.draw do
  get "post/say"

  match "/messages/:id/get_partial" => 'messages#get_partial'
  match "/messages/change_to_many_receivers" => 'messages#change_to_many_receivers'
  match "/messages/change_to_one_receiver" => 'messages#change_to_one_receiver'
  match "/messages/report_message" => "messages#report_message"
  match "/messages/comment_form" => "messages#comment_form"
  match "/messages/:id/reply_form" => 'messages#reply_form'

  resources :messages do
    member do
      get :as_sent, :reply
    end
    collection do
      get :sent
      get :archive
      get :w_instructors
    end
  end

  resources :chains do 
    member do
      post :archive
      post :unarchive
    end
  end

end
