module ApplicationHelper

	def signature(timestamp,noncestr)
		if !Rails.cache.read("#{@gzh_config.appid}_ticket")
			url="https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{@gzh_config.token}&type=jsapi"
			ticket=JSON.parse(ThirdParty.get_to_wechat(url))["ticket"]
			Rails.cache.write("#{@gzh_config.appid}_ticket",ticket,:expires_in=>6000)
		end
		query={	
			timestamp: timestamp,
			noncestr: noncestr,
			url: request.url,
			jsapi_ticket: Rails.cache.read("#{@gzh_config.appid}_ticket")
		}.sort.collect do |key, value|
			"#{key}=#{value}"
		end.join('&')
		Digest::SHA1.hexdigest(query)
	end
end
