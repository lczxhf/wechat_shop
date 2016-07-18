namespace :data do
  desc 'add some data to test'
  task :add => :environment do
      user = User.create(name:'test',status:1)
      Member = user.members.create(openid:'linzihao')
      user.create_gzh_config(appid:"123456")
  end

  desc 'clean product data'
  task :clean => :environment do
  		Product.destroy_all
		QrcodeImage.destroy_all
		Image.destroy_all
		LevelDistribution.destroy_all
  end
end
