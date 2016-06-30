module WechatReplyClass
class WText < WechatReplyClass::WBase
    def handle
    		common_handle
    end


    def common_handle
    		reply_text_message(@weixin_message.Content)
    end

end
end
