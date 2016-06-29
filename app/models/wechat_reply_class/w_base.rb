module WechatReplyClass
class WBase
    include ReplyWeixinMessage
    def initialize(weixin_message,gzh_config)
      @weixin_message = weixin_message
      @gzh_config = gzh_config
    end
end
end
