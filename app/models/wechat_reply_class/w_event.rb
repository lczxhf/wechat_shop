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
			member = Member.find_or_initialize_by(openid:@weixin_message.FromUserName)
			member.gzh_config_id = @gzh_config.id
			member.user_id = @gzh_config.user_id
			member.save
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
