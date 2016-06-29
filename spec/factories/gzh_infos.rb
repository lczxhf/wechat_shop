FactoryGirl.define do
  factory :gzh_info do
    association :gzh_config
    association :shop
    nickname {Faker::Name.name}
    headimgurl {Faker::Avatar.image}
    service_type 1
    verify_type 1
    user_name 'gzh'
    qrcode_url {Faker::Avatar.image}    
  end

end
