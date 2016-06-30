namespace :data_init do
  desc 'add some data to test'
  task :add => :environment do
      user = User.create(name:'test',status:1)
      Member = user.members.create(openid:'linzihao')
      user.create_gzh_config(appid:"123456")
  end


  task :remove => :environment do
      User.delete_all
      Member.delete_all
      GzhConfig.delete_all
      Rails.cache.clear
  end
end
