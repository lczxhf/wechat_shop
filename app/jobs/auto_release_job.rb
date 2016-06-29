class AutoReleaseJob < ApplicationJob
  queue_as :default

  def perform(code,openid,content)
	result = ThirdParty.authorize(code)
	puts Wechat.sent_custom_message(result['authorization_info']['authorizer_access_token'],openid,content)
  end
end
