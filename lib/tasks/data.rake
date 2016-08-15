namespace :data do
  desc 'add some data to test'
  task :add => :environment do
      user = User.create(name:'test',status:1)
  end

  desc 'clean product data'
  task :clean => :environment do
  		Product.destroy_all
		QrcodeImage.destroy_all
		Image.destroy_all
		LevelDistribution.destroy_all
  end
end
