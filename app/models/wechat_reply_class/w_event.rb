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
			@gzh_config.generate_member(@weixin_message.FromUserName)
            if @weixin_message.EventKey.present?
                scan
            else
                reply_text_message('welcome!')
        	end
        end

        def unsubscribe
        end

        def scan
        end

        def common_handle
        end
    end
end
