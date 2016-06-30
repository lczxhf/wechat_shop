class Api::V1::Page::ProductsController < Api::V1::ApplicationController
    require_token [:create]
    swagger_controller :weixin, 'yanzhiji api'
    swagger_api :upload do
        summary I18n.t('api_docs.product_create_summary')
        notes I18n.t('api_docs.product_create_note')
        param :form, :member, :integer, :required, 'member id'
        param :form, :upload, :file, :required, 'image'
        response :unauthorized
        response :not_acceptable
        response :requested_range_not_satisfiable
    end

    def create
        param! :member_id, Integer, required: true
        check_file :upload, required: true, max_size: 1024, file_type: %w(jpg jpeg)
        # record = ScanRecord.create(shop_id:params[:shop_id],image_path:params[:upload],randCode:params[:randCode])
        # UploadImgToWechatJob.perform_later(record.id)
        api_success('success')
    end
end
