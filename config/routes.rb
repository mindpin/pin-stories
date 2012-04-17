Voteapp::Application.routes.draw do  
  # -- 用户登录认证相关 --
  root :to=>"index#index"
  
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  # get  '/signup'        => 'signup#form'
  # post '/signup_submit' => 'signup#form_submit'
  
  # -- 以下可以自由添加其他 routes 配置项
  
  # -- 管理员界面
  
  get  '/admin'         => 'admin/admin#members'
  get  '/admin/members' => 'admin/admin#members'
  
  get  '/admin/members/new' => 'admin/admin#new_member'
  post '/admin/members'     => 'admin/admin#create_member'
  
  get  '/admin/members/:id/edit' => 'admin/admin#edit_member'
  put  '/admin/members/:id'      => 'admin/admin#update_member'
  
  # --
  
  resources :products do
    resources :streams
    resources :stories
  end
  get 'products/:id/members' => 'products#product_members'


  # -----
  
  resources :members
  resources :streams
  
  resources :stories do
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
