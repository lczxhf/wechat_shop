class ThirdParty::WechatController < ThirdParty::ApplicationController
	def home
		shop = Shop.find(params[:id]) rescue nil
		if shop
		    if shop.can_authorize?
			@url="https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=#{APPID}&pre_auth_code=#{Rails.cache.read(:pre_code)}&redirect_uri=#{Settings.website_url}/third_party/wechat/auth_code?id=#{params[:id]}"
 	 		render html: @url
 	 	    else
 	 		#TODO
 	 		render plain: I18n.t("returnCode.code_1002")
 	 	    end
		else
		    render plain: I18n.t("returnCode.code_1001")
		end
	end

	def receive
		if result = ThirdParty.get_content(request.body.read,params[:timestamp],params[:nonce],params[:msg_signature])
			case result.xml.InfoType.content.to_s
				when "component_verify_ticket" then
			   		verify_ticket = result.xml.ComponentVerifyTicket.content.to_s
			   		Rails.cache.write(:ticket,verify_ticket)
			   		access_token = ThirdParty.get_access_token
			   		Rails.cache.write(:pre_code,ThirdParty.get_pre_auth_code["pre_auth_code"])
				when "unauthorized" then
			   		appid = result.xml.AuthorizerAppid.content.to_s
			   		GzhConfig.fetch_cache(appid:appid).cancel_authorize
			end
		else
			puts 'error'
		end
		render plain: 'success'
	end

	def auth_code 
		puts params
		#TODO
		#consider some situation that shop's user change gzh or one gzh want to bind two shop

		json=ThirdParty.authorize(params[:auth_code])
		gzh_config = GzhConfig.generate_config(json,params[:id])
		#GetUserInfo.perform_async(auth_code.token,auth_code.id)
		gzh_config.update_gzh_info
		# gzh_config.set_industry()
		# gzh_config.add_template()
		# gzh_config.set_menu()
		redirect_to Settings.website_url+Settings.after_authorize
 	 end

 	 def oauth2
		if params[:code]
			result=Wechat.get_usertoken_by_code(params[:appid],params[:code])
			if result["openid"]
				#TODO
			end
		end		
	end

	def authorize
		if params[:code]
      		result=Wechat.get_usertoken_by_code(params[:appid],params[:code])
			if result["openid"]
				#TODO
			end
		end
	end
end
