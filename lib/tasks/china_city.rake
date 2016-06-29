#encoding:utf-8

require "json"
namespace :biz do
    desc "init china cities"
    task :init_china_cities => :environment do
        ChinaCity.delete_all

        file = File.open Rails.root.join('db', 'area.json').to_s
        json_str = file.readlines.join('')
        json = JSON::parse(json_str)
        json.each do |item|
            ChinaCity.create(name:item['text'], code:item['id'])
        end
    end
end
