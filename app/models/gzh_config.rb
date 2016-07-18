class GzhConfig < ApplicationRecord
	acts_as_cached(version:1,expires_in: 1.day)
	belongs_to :user
	has_one :gzh_info
	has_many :members

	default_scope { where(del: false) }
	after_find :check_token_expire

	class << self
		def generate_config(json,id)
			gzh_config = self.find_or_initialize_by(appid:json['authorization_info']['authorizer_appid'])
			gzh_config.token=json['authorization_info']['authorizer_access_token']
			gzh_config.del = false
			gzh_config.user_id = id
			gzh_config.refresh_token=json['authorization_info']['authorizer_refresh_token']
			gzh_config.tap {|gzh| gzh.save}
		end
	end

	def cancel_authorize
		#TODO
	end

	def update_gzh_info
		gzh_info = GzhInfo.find_or_initialize_by(gzh_config_id:self.id)
		result = Wechat.get_gzh_info(self.appid)['authorizer_info']
		gzh_info.user_id = self.user_id
		gzh_info.nickname=result['nick_name']
		gzh_info.headimgurl=result['head_img']
		gzh_info.service_type=result['service_type_info']['id']
		gzh_info.verify_type=result['verify_type_info']['id']
		gzh_info.user_name=result['user_name']
		gzh_info.alias=result['alias']
		gzh_info.qrcode_url=result['qrcode_url']
		result['business_info'].each do |k,v|
			gzh_info.send("#{k}=",v)
		end
		gzh_info.save
	end

	def refresh_gzh_token()
		result = ThirdParty.refresh_gzh_token(self.appid,self.refresh_token)
		if result['authorizer_refresh_token']
			self.refresh_token=result['authorizer_refresh_token']
			self.token=result['authorizer_access_token']
			self.save
		end
	end

	def set_industry()
		 one='39'
      	 two='24'
      	 Wechat.set_industry(self.token,one,two)
	end

	def add_template()

		template_list = Wechat.get_template_list(self.token)
		template_list = template_list['template_list'].collect {|a| a['template_id']}
		arr = TemplateMessage.where(template_id:template_list).pluck(:template_number_id)
		industry_type = 1
		template_number = TemplateNumber.where(industry_type:industry_type).where.not(number:arr).pluck(:number)
		template_number.each do |number|
			if templete_id = Wechat.add_template(self.token,number)['template_id']
				t_message=TemplateMessage.new
      			t_message.template_id=templete_id
      			t_message.sangna_config_id= self.id
      			t_message.template_number_id=number
      			t_message.save!
			end
		end

	end

	def set_menu()
#body='{"button":[{"name":"我的","sub_button":[{"type":"view","name":"我的卡券","url":"https://open.weixin.qq.com/connect/oauth2/authorize?appid='+self.appid+'&redirect_uri=http%3a%2f%2fcallback.mijiclub.com%2fapi%2fthird_party%2foauth2&response_type=code&scope=snsapi_base&state=123&component_appid='+APPID+'#wechat_redirect"},{"type":"view","name":"了解觅技","url":"http://mijiclub.com"}]},{"type":"scancode_push","name":"到场扫码","key":"rselfmenu_0_1"},{"type":"view","name":"商家登录","url":"http://mijiclub.com/weixin/Writeoff-page/businessOperation.html"}]}'
		body = %{{"button":[{"name":"上传","type":"view","url":"#{Settings.website_url}/page/products/new?appid=#{self.appid}"},{"name":"图片库","type":"view","url":"#{Settings.website_url}/page/products?appid=#{self.appid}"}]}}
		Wechat.set_menu(self.token,body)
	end

	def change_qrcode(sangna_config)
				MiniMagick::Tool::Convert.new do |convert|
							convert << '-size'
							convert << '380x190'
							convert << '-strip'
							convert << 'xc:none'
							convert <<  Rails.root.to_s+'/public'+self.qr_code.url
							convert << '-geometry'
							convert << '+0+0'
							convert << '-composite'
							convert << Rails.root.join("public","images","zhiwu.png")
							convert << '-geometry'
							convert << '+190+0'
							convert << '-composite'
							convert << Rails.root.to_s+'/public'+self.qr_code.url
				end
	end


	def generate_member(openid,token=nil)
			member = Member.find_or_initialize_by(openid:openid)
			if token
				info = Wechat.get_oauth2_info(openid,token)
			else
				info = Wechat.get_user_info(openid,self.token)
			end
			member.gzh_config_id = self.id
			member.user_id = self.user_id
			if info
				member.nickname=info['nickname']
				member.sex=info['sex'].to_i
				member.province=info['province']
				member.city=info['city']
				member.country=info['country']
				member.headimgurl=info['headimgurl']
				member.language=info['language']
				member.subscribe_time=info['subscribe_time']
				member.remark=info['remark']
			end
			member.save!
	end

	private

	def check_token_expire
		if Time.now - self.updated_at > 4500
			puts 'access_token invaild'
			self.refresh_gzh_token
	 	end
	end
end
