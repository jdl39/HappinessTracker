HappinessApp::Application.routes.draw do

  post 'happiness_response', to: 'happiness#post_happiness_response'

  root 'users#index'
  post 'users/login' => 'users#login'
  get 'new' => 'users#new'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  resources :users
  resources :sessions, only: [:create, :destroy] # removed "new"
  match '/signup',  to: 'users#new',            via: 'get'
  #match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'get'
  get '/track', to: 'search#index'
  get '/happiness', to: 'happiness#index'
  get '/happiness/:username', to: 'happiness#index'
  get '/quiz', to: 'happiness#quiz'
  post '/quiz_handler', to: 'happiness#post_happiness_quiz'
  get '/goals', to: 'goals#index'
  get '/goals/:username', to: 'goals#index'
  post '/goals/new', to: 'goals#new_goal'
  get '/goals/abandon/:id', to: 'goals#abandon_goal'
  get '/guides', to: 'guides#index'
  get '/guides/:username', to: 'guides#index'
  get '/inbox', to: 'messages#inbox'
  get '/inbox/:username', to: 'messages#show'
  get '/challenges', to: 'challenges#index'
  get '/challenges/:username', to: 'challenges#index'
  get '/friends/', to: 'friends#index'
  get '/friends/:username', to: 'friends#index'
  get '/friends/:username/json', to: 'friends#get_friends'
  get '/get_my_friends', to: 'friends#get_my_friends'

  get '/happiness_scores', to: 'happiness#get_happiness_scores'

  get 'blah', to: 'activities#delete_me'
  get 'get_comments', to: 'activities#getComments'
  get 'get_top_comments', to: 'activities#getTopComments'
  post 'submit_new_comment', to: 'activities#new_comment'
  post 'up_comment', to: 'activities#up_comment'
  post 'down_comment', to: 'activities#down_comment'
  get 'get_responses', to: 'activities#getResponses'
  post 'submit_new_response', to: 'activities#new_response'
  post 'submit_new_r_response', to: 'activities#new_r_response'
  post 'up_response', to: 'activities#up_response'
  post 'down_response', to: 'activities#down_response'
  
  get '/home', to: 'users#home'
  get '/search_data', to: 'activities#search'
  get '/search_more_data', to: 'activities#search_more'
  get '/search_get_specific_data', to: 'activities#get_activity_data'
  get '/get_activity_data', to: 'activities#get_activity_data'
  get '/create_activity', to: 'activities#create_activity'
  get '/track_activity', to: 'activities#track_new_measurement'
  get '/settings', to: 'users#settings'

  # PROFILE PAGE
  get '/profile/:username', to: 'users#profile' 
  get '/profile', to: 'users#profile'

  # FRIENDSHIP
  get '/friends/json/:user_id', to: 'friends#get_friends'   
  match '/friend_request/decline', to: 'friends#decline_request', via: 'post' #request_id
  match '/friend_request/accept', to: 'friends#accept_request', via: 'post' #request_id
  match '/friend_request/create', to: 'friends#create_request', via: 'post' #Params: user_id, friend_id
  get '/friend_request/:user_id/sent', to: 'friends#requests_sent'
  get '/friend_request/:user_id/received', to: 'friends#requests_received'

  # MESSAGES
  match '/messages/new', to: 'messages#new', via: 'post'
  get '/messages/:user_id', to: 'messages#inbox'

  # CHALLENGES
  get '/new_challenge', to: 'challenges#new'
  match '/challenges/accept', to: 'challenges#accept', via: 'post' #challenge_id
  match '/challenges/decline', to: 'challenges#decline', via: 'post' #challenge_id
  match '/challenges/complete', to: 'challenges#complete', via: 'post' #challenge_id
  get '/challenges/:user_id/accepted', to: 'challenges#retrieve_accepted'
  get '/challenges/:user_id/declined', to: 'challenges#retrieve_declined'
  get '/challenges/get/:message_id', to: 'challenges#get_challenge'

  # TEST FOR RECOMMENDATIONS
  get '/recommendations', to: 'activities#recommendations'

  # HAPPINESS PAGE
  match '/happiness_status/set', to: 'users#set_happy_status', via: 'post' #is_happy

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
