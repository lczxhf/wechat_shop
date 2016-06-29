FactoryGirl.define do
  factory :scan_record do
    association :shop
    association :user
    media_id {Faker::Bitcoin.address}
    randCode {Faker::Bitcoin.address}
    image_path "abc.jpg"
    pic_url {Faker::Avatar.image}
    factory :scan_record_without_randcode do
    	randCode ""
    end    
  end

end
