class Page::UsersController < Page::ApplicationController
	layout false
	def new
	end

	def create
		gzh_config = GzhConfig.fetch_cache(appid:params[:appid])
		if shop = current_member.is_own?
			shop.update_attributes(name:params[:name],service_phone:params[:service_phone],service_wechat:params[:service_wechat],address:params[:address],qrcode_url:params[:file])
			shop.shop_setting.update_attributes(can_wechatpay:params[:can_wechatpay],can_alipay:params[:can_alipay],can_unionpay:params[:can_unionpay],show_address:params[:show_address])
			if params[:distribution].present?
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
		@gzh_config = GzhConfig.first
	end
end
