module WechatReplyClass
class CommonHandle
	include ReplyWeixinMessage
	def initialize(hash,appid)
	  @weixin_message = Message.factory hash
	  @gzh_config = GzhConfig.fetch_cache(appid:appid)
	end
	def generate_class
	  if (result = check_whether_release) == false
		puts result
	    if (expire_result = check_expire) == false
	    	case @weixin_message.MsgType
      	    	when 'text'
        	  WText.new(@weixin_message,@gzh_config).handle
            	when 'image'
        	  WImage.new(@weixin_message,@gzh_config).handle
            	when 'location'
        	  WLocation.new(@weixin_message,@gzh_config).handle
            	when 'link'
        	  WLink.new(@weixin_message,@gzh_config).handle
            	when 'event'
        	  WEvent.new(@weixin_message,@gzh_config).handle
            	else
       		  raise ArgumentError, 'Unknown Weixin Message'
      	    	end
 	    else
		expire_result
	    end
	  else
	      result
	  end
	end


	def check_whether_release
	    return reply_text_message(@weixin_message.Event+'from_callback') if @weixin_message.MsgType == "event" && @weixin_message.ToUserName == "gh_3c884a361561"
	    return reply_text_message("TESTCOMPONENT_MSG_TYPE_TEXT_callback") if @weixin_message.MsgType == "text" && @weixin_message.Content == "TESTCOMPONENT_MSG_TYPE_TEXT"
	    if @weixin_message.MsgType == "text" && @weixin_message.ToUserName == "gh_3c884a361561"
		if @weixin_message.Content.include?("QUERY_AUTH_CODE:")
		    AutoReleaseJob.perform_later(@weixin_message.Content.gsub("QUERY_AUTH_CODE:",""),@weixin_message.FromUserName,@weixin_message.Content.gsub("QUERY_AUTH_CODE:","")+"_from_api")
		end
		return ""
	    end
	    false
	end

	def check_expire
	    return reply_text_message(I18n.t("returnCode.code_1005")) if @gzh_config.del == true || !@gzh_config.shop.can_authorize?
	    false 
	end
end
end
