Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  require 'sidetiq/web'
  mount Sidekiq::Web => '/third_party/sidekiq'
 # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
 namespace :third_party do
 	get "wechat/home" => "wechat#home"
 	post "wechat/receive" => "wechat#receive"
 	post 'message/:appid' => "message#receive"
 	get "wechat/auth_code" => "wechat#auth_code"
  	get "wechat/oauth2" => "wechat#oauth2"
  	get "wechat/authorize" => "wechat#authorize"
 end

post "/birthday" => "page/users#birthday"
 namespace :page do
	  resources :products
	  resources :users do
	  	get 'init',on: :collection
	  	post 'sent_code',on: :collection
		post 'init_shop', on: :collection
		get 'show_bind', on: :collection
		post "bind_wechat",on: :collection
	  end
	  resources :share_records do
	  	post 'sent_code', on: :collection
	  end

	  resources :orders do
	  	post :create_by_authorize, on: :collection
	  end
 end

 namespace :api do
   scope module: 'v1' do
     resource :auth_token, only: [:create]
   end
   namespace :v1 do
     namespace :page do
       resources :products
     end
   end
  end

end
