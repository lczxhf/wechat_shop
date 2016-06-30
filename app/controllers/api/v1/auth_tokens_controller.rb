class Api::V1::AuthTokensController < Api::V1::ApplicationController
	skip_before_action :verify_jwt
	swagger_controller :auth_token, 'get token'
	swagger_api :create do
		summary "get token"
		param :form, :user_id, :integer, :required, "id of user"
		response :unauthorized
	end
	def create
		param! :user_id, Integer, required: true
		user = User.find(params[:user_id]) rescue nil
		if user
		    if user.can_authorize?
		        token = create_jwt(user)
		        api_success(token)
		    else
			api_error(I18n.t("returnCode.code_1002"),1002)
		    end
		else
			api_error(I18n.t("returnCode.code_1001"),1001)
		end
	end

	private
	def create_jwt(user)
		secret_key = "123456789"
		payload = { userid: user.id}
		expire_at = set_auth_token_expired_time
		payload.merge!("exp" => expire_at)
		JWT.encode(payload, secret_key)
	end

	# 设置令牌7天过期
	def set_auth_token_expired_time
		7.days.from_now.to_i
	end
end
