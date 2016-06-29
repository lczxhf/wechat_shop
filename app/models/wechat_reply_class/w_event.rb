module WechatReplyClass
class WEvent < WechatReplyClass::WBase
    def handle
    	case @weixin_message.Event
    	when 'subscribe'
    		subscribe
    	when 'unsubscribe'
    		unsubscribe
    	when 'SCAN'
    		scan
    	else
    		common_handle
    	end
    end

    def subscribe
	   
       if @weixin_message.EventKey.present?
            scan
       else
	    reply_text_message("welcome!")
       end
	   
    end

    def unsubscribe
    end

    def scan
        record_id = @weixin_message.EventKey
	record = ScanRecord.find(record_id) rescue nil
	if record
	    reply_image_message(generate_image(record.get_media_id))
	else
	    reply_text_message(I18n.t("returnCode.code_1007"))
	end
    end

    def common_handle
    end
end
end
