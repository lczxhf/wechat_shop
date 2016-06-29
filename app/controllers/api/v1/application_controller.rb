class Api::V1::ApplicationController < ApplicationController
	protect_from_forgery with: :null_session
	skip_before_action :verify_authenticity_token
	before_action :verify_jwt
	class InvalidSizeError < RailsParam::Param::InvalidParameterError; end
	class InvalidTypeError < RailsParam::Param::InvalidParameterError; end
	class InvalidCheckTypeError < StandardError; end

	rescue_from(RailsParam::Param::InvalidParameterError) do |err|
	    #TODO
	    api_error(I18n.t("returnCode.code_1001"),1001)
	end


	rescue_from(InvalidSizeError) do |err|
	    api_error(I18n.t("returnCode.code_1003"),1003)
	end

	rescue_from(InvalidTypeError) do |err|
	    api_error(I18n.t("returnCode.code_1004"),1004)
	end

	def self.inherited(subclass)
		super
		subclass.send(:extend,ControllerClassMethod) unless subclass == Api::V1::AuthTokensController
	end
	def api_error(message,status = 1001)
	    #TODO
	    render json: %{{"#{Settings.return_json_status_name}":#{status},"#{Settings.return_err_result_name}":"#{message}"}}
	end
	
	def api_success(result,status = 200)
	    render json: %{{"#{Settings.return_json_status_name}":#{status},"#{Settings.return_success_result_name}":"#{result}"}}

	end

	def current_shop
		jwt = params["token"]
		return false unless jwt
		payload, header = JWT.decode(jwt, nil, false, verify_expiration: false) 
		shop = Shop.find(payload["shopid"])
		secret = account ? "123456789" : "" 
		payload, header = JWT.decode(jwt, secret) 
		@current_user = shop
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

	def verify_jwt
		unless current_shop
			#TODO
			#do something if token is empty
		end
	
		rescue JWT::ExpiredSignature => e
		    api_error("token expire")
		rescue JWT::DecodeError => e
		    api_error("token error!")
	end
end

module ControllerClassMethod
	def require_token(arg)
	  arg.each do |method|
	    swagger_api method do
              param :query, 'token', :string, :required, 'Authentication token'
            end
	   end
	end
end
