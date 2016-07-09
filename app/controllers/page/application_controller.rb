class Page::ApplicationController < ApplicationController
#protect_from_forgery with: :exception
	before_action :check_login
	class InvalidSizeError < RailsParam::Param::InvalidParameterError; end
	class InvalidTypeError < RailsParam::Param::InvalidParameterError; end
	class InvalidCheckTypeError < StandardError; end

	rescue_from(RailsParam::Param::InvalidParameterError) do |err|
	    #TODO
	    #api_error(I18n.t("returnCode.code_1001"),1001)
	end


	rescue_from(InvalidSizeError) do |err|
	    #api_error(I18n.t("returnCode.code_1003"),1003)
			#TODO
	end

	rescue_from(InvalidTypeError) do |err|
	    #api_error(I18n.t("returnCode.code_1004"),1004)
			#TODO
	end

	def return_error(message,status = 1001)
		render json: %{{"#{Settings.return_json_status_name}":#{status},"#{Settings.return_err_result_name}":"#{message}"}}
	end

	def return_success(message,status = 200)
		render json: %{{"#{Settings.return_json_status_name}":#{status},"#{Settings.return_success_result_name}":"#{message}"}}
	end
	
	def check_file(name,opt={})
	    if params[name.to_sym].present?
					opt.each do |k,v|
						send("check_"+k.to_s,params[name.to_sym],v) if respond_to?("check_"+k.to_s)
					end
	    else
	    	raise RailsParam::Param::InvalidParameterError if opt[:required] == true
	    end
	end

	def check_file_type(obj,value)
		filename = obj.original_filename.gsub(/.*\./,"")
		case value
		when Symbol
		  raise InvalidTypeError if  filename != value.to_s
		when String
		  raise InvalidTypeError if filename != value
		when Array
		  raise InvalidTypeError if !value.map {|a| a.to_s}.include?(filename)
		else
		  raise InvalidCheckTypeError
		end
	end

	def check_max_size(obj,value)
		size = (obj.size.to_i)/1000
		case value
		when Fixnum
		  raise InvalidSizeError if size > value
		else
		  raise InvalidCheckTypeError
		end
	end


	def current_member
		@current_member ||= Member.fetch_cache(openid:session[:openid])
	end

	def check_login
		unless session[:openid]	
			cookies.signed[:next_url]=request.url
			auth_url="https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{params[:appid]}&redirect_uri=#{Settings.website_url}/third_party/wechat/authorize&response_type=code&scope=snsapi_userinfo&state=123&component_appid=#{APPID}#wechat_redirect"
			redirect_to auth_url
		else
			unless current_member
				return_error("you have openid but this not exist in our database")
			end
		end
	end
end
