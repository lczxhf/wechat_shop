class Api::V1::Fashion::WeixinController < Api::V1::ApplicationController
	require_token [:upload,:upload_without_randcode]
	swagger_controller :weixin, "yanzhiji api"
	swagger_api :upload do
  		summary I18n.t("api_docs.fashion_weixin_upload_summary")
  		notes I18n.t("api_docs.fashion_weixin_upload_notes")
  		param :form, :shop_id, :integer, :required, "company id"
  		param :form, :randCode, :string, :required, "uniq rand code"
  		param :form, :upload, :file, :required, "image"
  		response :unauthorized
  		response :not_acceptable
  		response :requested_range_not_satisfiable
	end  
	swagger_api :upload_without_randcode do
  		summary I18n.t("api_docs.fashion_weixin_upload_without_randcode_summary")
  		notes I18n.t("api_docs.fashion_weixin_upload_without_randcode_notes")
  		param :form, :shop_id, :integer, :required, "company id"
  		param :form, :upload, :file, :required, "image"
  		response :unauthorized
  		response :not_acceptable
  		response :requested_range_not_satisfiable
	end

    def upload
	param! :shop_id, Integer, required: true
	param! :randCode, String,required: true
	check_file :upload, required: true,max_size:1024, file_type: ['jpg','jpeg']
	#record = ScanRecord.create(shop_id:params[:shop_id],image_path:params[:upload],randCode:params[:randCode])
 	#UploadImgToWechatJob.perform_later(record.id)	
	api_success("success")
    end

    def upload_without_randcode
	param! :shop_id, Integer, required: true
	check_file :upload, required: true,max_size:1024, file_type: ['jpg','jpeg']
	#record = ScanRecord.create(shop_id:params[:shop_id],image_path:params[:upload])
	#url = record.get_qrcode	
 	#UploadImgToWechatJob.perform_later(record.id)	
	api_success(url)
    end

end
