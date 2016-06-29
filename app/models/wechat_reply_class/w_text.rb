module WechatReplyClass
class WText < WechatReplyClass::WBase
    def handle
    		common_handle
    end


    def common_handle
    		get_img_by_randCode
    end

    def get_img_by_randCode
	record = ScanRecord.where(randCode:@weixin_message.Content,shop_id:@gzh_config.shop_id).first
	if record
	  reply_imag_message(generate_image(record.get_media_id))
	else
	  reply_text_message(I18n.t("returnCode.code_1006"))
	end
    end
end
end
