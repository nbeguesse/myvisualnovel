MyVisualNovel::Application.routes.draw do


  resource :user_sessions
  match 'play/:id/null' => proc { [404, {}, ['']] }#for IE9 SoundManager
  match 'play/:id/:basename' => 'projects#play', :as=>:play
  resources :projects do
    resources :characters
    resources :scenes do
      member do
        post :update_event
        post :reorder
      end
      resources :events
    end
  end
  match 'projects/:project_id/toggle_character/:character_type' => 'characters#toggle', :as=>:toggle_character
  match 'events/:id/delete' => 'events#delete', :as => :delete_event
  match 'events/:id/moveup' => 'events#moveup', :as => :moveup_event
  match 'events/:id/movedown' => 'events#movedown', :as => :movedown_event
  match 'play/:id/:basename/scene/null' => proc { [404, {}, ['']] }#for IE9 SoundManager
  match 'play/:id/:basename/scene/:scene_id' => 'projects#play', :as=>:play_scene 

  resources :users do
    member do
      put :change_password
    end
  end

  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login
  match 'main/terms' => 'main#terms_of_service', :as=>:terms_of_service
  match 'forum' => "main#forum", :as=>:forum
  match 'not_found' => 'main#not_found', :as => :not_found
  match 'main/cookie' => "main#cookie", :as=>:cookie
  match 'i' => "imager#get", :as=>:imager
  # match 'i/BackgroundImage/:folder/:filename.:format' => "imager#get", :as=>:imager
  root :to => 'main#index'


end
