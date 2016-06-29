class ThirdParty::MessageController < ThirdParty::ApplicationController
	require "nokogiri"
	def receive
		if result = ThirdParty.get_content(request.body.read,params[:timestamp],params[:nonce],params[:msg_signature])
			hash={}
			puts result
			result.xml.css('*').each do |a|
			    hash[a.node_name]=a.content
			end
			result = WechatReplyClass::CommonHandle.new(hash,params[:appid]).generate_class()
			render xml: result	
		end
	end
end
