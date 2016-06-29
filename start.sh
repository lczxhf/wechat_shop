#!/bin/bash
/usr/sbin/sshd
cd /projects/wechat_shop
bundle install
#bundle exec rake assets:precompile
rake db:create
bin/rails db:migrate RAILS_ENV=development 
bundle exec sidekiq -C ./config/sidekiq.yml -d
bundle exec puma -C ./config/puma.rb

