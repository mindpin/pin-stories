Voteapp::Application.routes.draw do  
  # -- 用户登录认证相关 --
  root :to => 'index#index'
  
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  # get  '/signup'        => 'signup#form'
  # post '/signup_submit' => 'signup#form_submit'
  
  # -- 以下可以自由添加其他 routes 配置项
  
  # -- 管理员界面
  
  namespace :admin do
    get  '/'         => 'admin#members'
    get  '/members'  => 'admin#members'
    
    get  '/members/new' => 'admin#new_member'
    post '/members'     => 'admin#create_member'
    
    get  '/members/:id/edit' => 'admin#edit_member'
    put  '/members/:id'      => 'admin#update_member'
  end

  
  # --
  
  resources :products do
    resources :stories, :only => [:new, :create]
    resources :streams, :only => [:new, :create]
    resources :issues,  :only => [:new, :create]
    resources :lemmas,  :only => [:new, :create]
  end
  get 'products/:id/members' => 'products#product_members'
  get 'products/:id/issues'  => 'products#product_issues'
  get 'products/:id/lemmas'  => 'products#product_lemmas'


  get '/products/:product_id/wiki/:title'  => 'wiki#show'
  get '/products/:product_id/wiki'  => 'wiki#index'
  get '/products/:product_id/wiki_new'  => 'wiki#new'
  get '/products/:product_id/wiki/:title/edit'  => 'wiki#edit'

  put '/products/:product_id/wiki/:title'  => 'wiki#update'
  delete '/products/:product_id/wiki/:title'  => 'wiki#destroy'

  get '/products/:product_id/wiki/:title/versions'  => 'wiki#versions'
  get '/products/:product_id/wiki/:title/rollback/:audit_id' => 'wiki#page_rollback'
  get '/atme/:name' => 'wiki#atme'




  resources :wiki do
    collection do
      get :history
      post :preview
    end
    
    member do
    end
  end
  
  #get 'wiki/rollback/:audit_id' => 'wiki#rollback'
  
  
  resources :wiki

  # -----
  
  resources :members

  resources :streams, :except => [:new, :create]
  
  resources :stories, :except => [:new, :create] do
    member do
      get :assign_streams
      put :do_assign_streams
      get :assign_users
      put :do_assign_users
      put :change_status
    end
  end
  get '/mine' => 'stories#mine'
  
end
