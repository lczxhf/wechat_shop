FactoryGirl.define do
  factory :gzh_config do
	appid '123456789'
    	token 'sensetime'
    	refresh_token 'refresh_token'
    	del false
    	association :shop    
  end

end
