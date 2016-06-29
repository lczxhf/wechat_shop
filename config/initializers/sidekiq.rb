redis_server = Rails.application.secrets.redis_server
redis_port = Rails.application.secrets.redis_port
redis_db_num = Rails.application.secrets.redis_db_num
redis_namespace = Rails.application.secrets.redis_namespace
redis_password=Rails.application.secrets.redis_password	

Sidekiq.configure_server do |config|
	user = redis_password.present? ? ":#{redis_password}@" : ""
	config.redis = { url: "redis://#{user}#{redis_server}:#{redis_port}/#{redis_db_num}", namespace: redis_namespace }
end
	
Sidekiq.configure_client do |config|
	user = redis_password.present? ? ":#{redis_password}@" : ""
	config.redis = { url: "redis://#{user}#{redis_server}:#{redis_port}/#{redis_db_num}", namespace: redis_namespace }
end