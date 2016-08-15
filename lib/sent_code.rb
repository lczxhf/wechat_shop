require "rexml/document"
class SentCode
	def self.sent(phone,code)
		uri = URI("http://106.ihuyi.cn/webservice/sms.php?method=Submit")
		Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
	 		request= Net::HTTP::Post.new(uri,{'Content-Type'=>'application/json'})
	 		request.set_form_data({"account"=>"cf_zxy0506","password"=>"frymax2012","mobile"=>"#{phone}","content"=>"您的验证码是：#{code}。请不要把验证码泄露给其他人。如非本人操作，可不用理会！"})
			response=http.request request
			result = REXML::Document.new response.body
			result.root
		end
	end
end
