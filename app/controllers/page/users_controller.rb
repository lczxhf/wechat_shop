class Page::UsersController < Page::ApplicationController
	layout false
	require 'net/http/post/multipart'
	def new
		if @shop = current_member.is_own?
		else
			return_error("该用户不是此店的管理员",1008)
		end
	end

	def init
		
	end

	def sent_code
		if !Shop.exists?(phone:params[:phone]) && !Shop.exists?(openid:current_member.openid)
			code =rand(1000..9999).to_s
			result = SentCode.sent(params[:phone],code)
			if result.get_elements("code")[0][0].to_s == "2"
				Rails.cache.write(params[:phone],code,:expire_in=>1.hour)
			end
			return_success result.get_elements('msg')[0][0].to_s
		else
			return_error("该手机号码已经注册过店家",1009)
		end
	end

	def init_shop
		if Rails.cache.read(params[:phone])
			if params[:code] == Rails.cache.read(params[:phone])
				shop = Shop.create(phone:params[:phone],openid:current_member.openid)	
				Rails.cache.delete(params[:phone])
				return_success("成功")
			else
				return_error("验证码错误",1010)
			end	
		else
			return_error("验证码失效,请重新获取",1011)
		end
	end

	def show_bind
	end

	def bind_wechat
	end

	def create
		if shop = current_member.is_own?
			shop.update_attributes(name:params[:name],service_phone:params[:service_phone],service_wechat:params[:service_wechat],address:params[:address],qrcode_url:params[:file])
			shop.shop_setting.update_attributes(can_wechatpay:params[:can_wechatpay],can_alipay:params[:can_alipay],can_unionpay:params[:can_unionpay],show_address:params[:show_address])
			if params[:distribution].present? && shop.agent_num.to_i == 0
				params[:distribution].each_with_index do |a,index|
					data = a.split(',')
					AgentLevel.create(shop_id:shop.id,level:index+1,name:data[0],agent_min_price:data[1],level_price:data[2],can_create_agent:data[3])
					shop.agent_num.increment
				end
			end
			return_success("提交成功")
		else
			return_error("该用户不是此店的管理员",1008)
		end
	end

	def birthday
		result=nil
		api_id = "b03353c938f644e5a4c5234d5897ea5e"
		api_secret = "481ff75501b14de98a51dffa1424b12c"
		url = URI.parse("https://v1-api.visioncloudapi.com/face/detection")
		req = Net::HTTP::Post::Multipart.new url,"file" => UploadIO.new(params[:file],"image/jpeg"),"api_id"=>api_id,"api_secret"=>api_secret
		res = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
			result = JSON.parse http.request(req).body        
		end
		puts result
		render json: result['faces'][0]['landmarks21'][0]
	end
end
