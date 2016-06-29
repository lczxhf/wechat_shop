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

 namespace :page do
	get "members/new" => "members#new"
 end

 namespace :api do
  scope module: 'v1' do
    resource :auth_token, only: [:create]
  end
 end
 scope module: "api" do
  scope module: "v1" do
    namespace :fashion do
	post "weixin/upload" => "weixin#upload"
	post "weixin/upload_without_randcode" => "weixin#upload_without_randcode"
    end
  end
 end
end
