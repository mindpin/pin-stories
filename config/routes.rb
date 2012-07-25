MindpinAgile::Application.routes.draw do  
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
    resources :issues,  :only => [:new, :create, :index]
    resources :lemmas,  :only => [:new, :create]
  end

  get 'products/:id/members' => 'products#product_members'
  get 'products/:id/lemmas'  => 'products#product_lemmas'


  # activities
  get 'products/:id/activities' => 'products#activities'

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

      get '/:title/edit_section'   => 'wiki#edit_section'
      put '/:title/update_section' => 'wiki#update_section'


      get '/:title/refs'  => 'wiki#refs'
    end

    get  '/wiki_new' => 'wiki#new'

    #  开始 evernote 路由
    get  '/wiki_evernote_connect'       => 'evernote#connect'
    get  '/wiki_evernote_callback'      => 'evernote#callback'
    get  '/wiki_evernote_import'        => 'evernote#import'
    post '/wiki_evernote_confirmimport' => 'evernote#confirm_import'
    post '/wiki_evernote_doimport'      => 'evernote#do_import'
    #  结束 evernote

    post '/wiki'         => 'wiki#create'
    post '/wiki_preview' => 'wiki#preview'

    get  '/wiki_orphan'  => 'wiki#orphan'

    # wiki 全文搜索
    get  '/wiki_search'  => 'wiki#search'

    # story 全文搜索
    get  '/stories_search' => 'stories#search'
  end

  # wiki  draft
  post '/wiki_save_new_draft' => 'wiki#save_new_draft'
  post '/wiki_save_draft' => 'wiki#save_draft'
  get '/wiki_get_draft' => 'wiki#get_draft'

  get '/atme/:name' => 'atme#atme'

  resources :drafts

  # -------------------
  
  resources :users

  resources :streams, :except => [:new, :create]
  
  # 全文索引，搜索我的故事
  get '/my_stories_search' => 'stories#search_mine'

  resources :stories, :except => [:new, :create] do
    collection do
      post :save_new_draft
      post :save_draft
      get  :get_draft
    end

    member do
      get :assign_streams
      put :do_assign_streams
      get :assign_users
      put :do_assign_users
      put :change_status
    end
  end
  get '/mine' => 'stories#mine'

  # 历史回滚
  get '/stories/:id/versions'          => 'stories#versions'
  get '/stories/:id/rollback/:version' => 'stories#rollback'

  # story 保存到 wiki
  get '/stories/:id/save_to_wiki'      => 'stories#save_to_wiki'

  # 所有类型的评论都在这里，不单独定义
  resources :comments do
    collection do
      get 'show_model_comments'
    end
  end

  # issues
  resources :issues, :except => [:new, :create]
end
