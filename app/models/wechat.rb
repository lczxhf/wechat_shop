class Wechat
	require 'net/http/post/multipart'
	class << self
	#向微信发起刷新token的请求
	#返回xml
	def refresh_token(appid,refresh_token,c_appid,c_token)
		url="https://api.weixin.qq.com/sns/oauth2/component/refresh_token?appid=#{appid}&grant_type=refresh_token&component_appid=#{c_appid}&component_access_token=#{c_token}&refresh_token="+refresh_token
		body=""
		ThirdParty.sent_to_wechat(url,body)
	end	
	
	#向微信发起发送模板消息请求!
	#并返回发送结果
	#参数: url为点击模板消息后的跳转页面
	#     hash为填充模板消息内容的键值对
	def sent_template_message(token,openid,template_id,url,hash)
		 	template_url='https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='+token
			data=""
		    hash.each do |key,value|
				data+='"'+key+'":{"value":"'+value+'","color":"#173177"},'
			end	
			data=data[0...data.length-1]
            template_body='{"touser":"'+openid+'","template_id":"'+template_id+'","url":"'+url+'","topcolor":"#FF0000","data":{'+data+'}}'
            template_result=JSON.parse(ThirdParty.sent_to_wechat(template_url,template_body))
            puts template_result
            template_result
	end

	def set_industry(token,one,two)
		url="https://api.weixin.qq.com/cgi-bin/template/api_set_industry?access_token="+token
		body='{"industry_id1":"'+one+'","industry_id2":"'+two+'"}'
		ThirdParty.sent_to_wechat(url,body)
	end

	def get_template_list(token)
		url = "https://api.weixin.qq.com/cgi-bin/template/get_all_private_template?access_token="+token
		JSON.parse(ThirdParty.get_to_wechat(url))
	end

	def add_template(token,template_number)
		url="https://api.weixin.qq.com/cgi-bin/template/api_add_template?access_token="+token
		body='{"template_id_short":"'+template_number+'"}'
		result=JSON.parse(ThirdParty.sent_to_wechat(url,body))
		puts result
		result
	end

	def set_menu(token,body)
		url='https://api.weixin.qq.com/cgi-bin/menu/create?access_token='+token
		result=ThirdParty.sent_to_wechat(url,body)
		puts result
	end

	def get_menu_info(token)
		url = "https://api.weixin.qq.com/cgi-bin/get_current_selfmenu_info?access_token="+token
		result = ThirdParty.get_to_wechat(url)
	end

	def get_auto_response_info(token)
		url="https://api.weixin.qq.com/cgi-bin/get_current_autoreply_info?access_token="+token
		result = ThirdParty.get_to_wechat(url)
	end

	def get_gzh_info(appid)
		url='https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token='+ThirdParty.get_access_token
		body='{"component_appid":"'+APPID+'","authorizer_appid":"'+appid+'"}'
		result=JSON.parse(ThirdParty.sent_to_wechat(url,body))
	end

	def get_usertoken_by_code(appid,code)
		url="https://api.weixin.qq.com/sns/oauth2/component/access_token?appid=#{appid}&code=#{code}&grant_type=authorization_code&component_appid=#{APPID}&component_access_token="+ThirdParty.get_access_token
		JSON.parse(ThirdParty.get_to_wechat(url))
	end
	#向微信请求生成场景二维码
	#并返回请求结果
	#参数: action为二维码的类型
	def get_qrcode(token,action,expire="",info)
	url="https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token="+token
		case action
		when 'QR_SCENE' then
		   body='{"expire_seconds":'+expire.to_s+', "action_name": "QR_SCENE", "action_info": {"scene": {"scene_id":'+info.to_s+'}}}'
		when 'QR_LIMIT_SCENE' then
		    body='{"action_name": "QR_LIMIT_SCENE", "action_info": {"scene": {"scene_id":'+info.to_s+'}}}'
		when 'QR_LIMIT_STR_SCENE'
		    body='{"action_name": "QR_LIMIT_STR_SCENE", "action_info": {"scene": {"scene_str":'+info+'}}}'
		end
     result = ThirdParty.sent_to_wechat(url,body)
	end
	

	#根据ticket向微信拿回二维码图片
	def fetch_qrcode(ticket)
		url='https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket='+ticket
		ThirdParty.get_to_wechat(url)	
	end
	
	#长链接转短链接
	def long2short(token,long_url)
		url='https://api.weixin.qq.com/cgi-bin/shorturl?access_token='+token
		body='{"action":"long2short","long_url":"'+long_url+'"}'
		ThirdParty.sent_to_wechat(url,body)
	end
	
	#上传meida!
	def upload_media(token,media,type,name)
		url = URI.parse('https://api.weixin.qq.com/cgi-bin/media/upload?access_token='+token+'&type='+type)
		req = Net::HTTP::Post::Multipart.new url,
  		"media" =>UploadIO.new(media,name)
		res = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
  		http.request(req).body	
	        end
        end
	
	#根据media_id获取media
	def get_media(token,media_id)
		url=URI.parse('https://api.weixin.qq.com/cgi-bin/media/get?access_token='+token+'&media_id='+media_id)
		ThirdParty.get_to_wechat(url)
	end
	

	#长传永久media
	def upload_forever_media(token,type,media,name,title="",introduction="")
		url=URI.parse('https://api.weixin.qq.com/cgi-bin/material/add_material?access_token='+token)
		   description='{"title":"'+title+'","introduction":"'+introduction+'"}'
		 req = Net::HTTP::Post::Multipart.new url,
     "media" =>UploadIO.new(media,name),
		"type" =>type,
		"description"=>description
                res = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
                http.request(req).body        
                end
	end

	def upload_news_img(token,media,name)
		url = URI.parse("https://api.weixin.qq.com/cgi-bin/media/uploadimg?access_token="+token)
		req = Net::HTTP::Post::Multipart.new url,"media" => UploadIO.new(media,name)
		res = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
                http.request(req).body        
        end
	end

	#获取用户的基本信息
	def get_user_info(openid,token,json = true)
 		   url="https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{token}&openid=#{openid}&lang=zh_CN"
 		   info=ThirdParty.get_to_wechat(url)
 		   puts info
 		   if json
 		   		JSON.parse(info)
 		   else
 		   		info
		   end
	end


	#或者用户的授权信息
	def get_oauth2_info(openid,token)
				url="https://api.weixin.qq.com/sns/userinfo?access_token=#{token}&openid=#{openid}&lang=zh_CN"
				info=JSON.parse(ThirdParty.get_to_wechat(url)) 
				puts info
				info
	end

	#上传news类型的media
	def upload_news(token,array)
		url='https://api.weixin.qq.com/cgi-bin/material/add_news?access_token='+token
		body='{"articles":['
		array.each do |content|
		body+=%{{"title":"#{content["title"]}","thumb_media_id":"#{content["media_id"]}","author":"#{content["author"]}","digest":"#{content["digest"]}","show_cover_pic":"#{content["is_cover"]}","content":"#{content["content"].gsub('"','\"')}","content_source_url":"#{content["url"]}"},}
		end
		body=body[0...body.length-1]+']}'
		ThirdParty.sent_to_wechat(url,body)
	end
	
	#根据media_id更新media
	def update_news(token,media_id,index,hash)
		url='https://api.weixin.qq.com/cgi-bin/material/update_news?access_token='+token
		body=%{{"media_id":"#{media_id}","index":"#{index}","articles":{"title":"#{hash['title']}","thumb_media_id":"#{hash['media_id']}","author":"#{hash['author']}","digest":"#{hash['digest']}","show_cover_pic":"#{hash['is_cover']}","content":"#{hash['content'].gsub('"','\"')}","content_source_url":"#{hash['url']}"}}}
		ThirdParty.sent_to_wechat(url,body)
	end
	
	#根据media_id获取media或者删除media
	def get_or_del_forever_media(token,media_id,type='get')
		url='https://api.weixin.qq.com/cgi-bin/material/'+type+'_material?access_token='+token
		body='{"media_id":"'+media_id+'"}'
		ThirdParty.sent_to_wechat(url,body)
	end
	
	#获取media的数量
	def get_media_sum(token)
		url='https://api.weixin.qq.com/cgi-bin/material/get_materialcount?access_token='+token
		ThridParty.get_to_wechat(url)
	end
	
	#获取media列表
	#参数  offset:跳过的个数
	#      count:获取的数量
	def get_media_list(token,type,offset,count)
		url='https://api.weixin.qq.com/cgi-bin/material/batchget_material?access_token='+token
		body='{"type":"'+type+'","offset":"'+offset+'","count":"'+count+'"}'
		ThirdParty.sent_to_wechat(url,body)
	end

	#根据group_id发送群发消息
	def sentall_by_group(token,is_to_all,group_id,type,array)
		url,body=return_url_body('group',token,['filter',is_to_all,group_id],type,array)
		ThirdParty.sent_to_wechat(url,body)
	end

	#根据openid发送群发消息
	def sentall_by_openid(token,arr_openid,type,array)
		url,body=return_url_body('openid',token,['touser',arr_openid],type,array)
		ThirdParty.sent_to_wechat(url,body)
	end

	def sentall_preview(token,openid,type,array)
		url,body=return_url_body('preview',token,['touser',openid],type,array)
		url='https://api.weixin.qq.com/cgi-bin/message/mass/preview?access_token='+token
		ThirdParty.sent_to_wechat(url,body)
	end
	
	def sent_custom_message(token,openid,content)
		url="https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="+token
		body='{"touser":"'+openid+'","msgtype":"text","text":{"content":"'+content+'"}}'
		result=	JSON.parse(ThirdParty.sent_to_wechat(url,body))
	end


	private
	 def return_url_body(by_what,token,first,type,array)
		if by_what=='group'
		   url='https://api.weixin.qq.com/cgi-bin/message/mass/sendall?access_token='+token
		   body='{"'+first[0]+'":{"is_to_all":'+first[1]+'"group_id":"'+first[2]+'"},"'
		else
		   url='https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token='+token
		   if by_what=='preview'
		     body='{"'+first[0]+'":"'+first[1]+'","'
		   else
		     body='{"'+first[0]+'":'+first[1].inspect+',"'
	   	   end
		end
		if type=='mpvideo'
		   url1='https://api.weixin.qq.com/cgi-bin/media/uploadvideo?access_token='+token
                        body1='{"media_id":"'+array[1]+'","title":"'+array[2]+'","description":"'+array[3]+'"}'
                        array[1]=JSON.parse(ThirdParty.sent_to_wechat(url1,body1))['media_id']
		end
		body+=type+'":{"'+array[0]+'":"'+array[1]+'"},"msgtype":"'+type+'"}'	
		return url,body
	 end
  	end
end
