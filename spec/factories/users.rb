FactoryGirl.define do
  factory :user do
    association :shop
    association :gzh_config
    openid {Faker::Bitcoin.address}
    nickname {Faker::Name.name}
    sex	{Faker::Boolean.boolean}
    city {Faker::Address.city }
    country {Faker::Address.country}
    province {Faker::Address.state}
    language "zh-CN"
    headimgurl {Faker::Avatar.image}
    subscribe_time {Faker::Time.between(DateTime.now - 3, DateTime.now).to_i}    
  end

end
