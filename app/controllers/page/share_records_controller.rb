class Page::ShareRecordsController < Page::ApplicationController
	layout false

	def new
		if level = current_member.get_level
			@agent_levels = current_member.get_shop.agent_levels.where("level >= #{level}")
			if level != 0
				if AgentLevel.can_authorize_agent?(@agent_levels,level)
					@agent_levels = @agent_levels[1..-1]
				else
					return_error("您没有权限授权下一级代理",1013)
				end	
			end
			
		else
			return_error("您不是店铺管理员或代理",1012)
		end
	end

	def create
		agent_level = AgentLevel.find(params[:level_id])
		if share_record = ShareRecord.create(from_member_id:current_member.id,level:agent_level.level,shop_id:agent_level.shop_id,price:agent_level.agent_min_price)
			url = Settings.website_url+"/page/share_records/#{share_record.id}?appid=#{params[:appid]}"
			name = Mybase64.encode(share_record.id.to_s)+".png"
			path = "/uploads/share_records/#{share_record.id}/#{name}"
			full_path = Rails.root.to_s+"/public"+path
			GenerateQrcode.generate(url,full_path,"h")
			ActiveRecord::Base.connection.execute("update share_records set qrcode='#{name}' where id=#{share_record.id}")		
			return_success(path)
		else
			return_error("创建失败")
		end
	end

	def show_test
		share_record = ShareRecord.find(params[:id])
		  if Time.now - share_record.created_at < Settings.qrcode_expire.minutes
			if share_record.from_member_id != current_member.id
				if share_record.sent?
					#TODO
					share_record.to_member_id = current_member.id
					share_record.status = "receive"
					share_record.save
					return_success("ok")
				else
					return_error("改二维码只能一个用户扫",1014)
				end
			else
				return_error("请让要授权的代理扫码")	
			end
		else
			return_error("二维码失效",1015)
		end
	end

	def show
		@share_record = ShareRecord.find(params[:id])
		@member = Member.find(@share_record.from_member_id)
		@products = @member.get_threshold_products
		@min_price = @member.get_shop.agent_levels.where(level:@share_record.level).first.agent_min_price
	end

	def sent_code
		if !Member.exists?(phone:params[:phone])
			code =rand(1000..9999).to_s
			result = SentCode.sent(params[:phone],code)
			if result.get_elements("code")[0][0].to_s == "2"
				Rails.cache.write(params[:phone],code,:expire_in=>1.hour)
			end
			return_success result.get_elements('msg')[0][0].to_s
		else
			return_error("该手机号码已经被其他用户使用",1016)
		end
	end

end
