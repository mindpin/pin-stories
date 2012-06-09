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

  
  # --------
  
  resources :products do
    resources :stories, :only => [:new, :create]
    resources :streams, :only => [:new, :create]
    resources :issues,  :only => [:new, :create]
    resources :lemmas,  :only => [:new, :create]
  end
  get 'products/:id/members' => 'products#product_members'
  get 'products/:id/issues'  => 'products#product_issues'
  get 'products/:id/lemmas'  => 'products#product_lemmas'


  # ---------------
  # WIKI 相关
  scope '/products/:product_id' do
    scope '/wiki' do
      get '/'            => 'wiki#index'
      get '/:title'      => 'wiki#show'

      get '/:title/edit' => 'wiki#edit'
      put '/:title'      => 'wiki#update'

      get '/:title/versions'          => 'wiki#versions'
      get '/:title/rollback/:version' => 'wiki#rollback'

      delete '/:title' => 'wiki#destroy'

      get '/:title/edit_section' => 'wiki#edit_section'

      get '/:title/refs'  => 'wiki#refs'
    end

    get  '/wiki_new' => 'wiki#new'
    post '/wiki'     => 'wiki#create'

    get '/wiki_orphan' => 'wiki#orphan'
  end


  # put '/products/:product_id/wiki/:title/update_section' => 'wiki#update_section'


  # get '/atme/:name' => 'wiki#atme'

  # -------------------
  
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
