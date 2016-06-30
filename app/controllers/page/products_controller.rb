class Page::ProductsController < Page::ApplicationController
  def create
    check_file :upload, required: true, max_size: 1024, file_type: %w(jpg jpeg png)
    if current_member.has_authority?
        ActiveRecord::Base.transaction do
          prodcut = current_member.products.create!(user_id:current_member.user_id)
          image = product.images.create!(member_id:current_member.id,path:params[:upload])
        end
        AddQrcodeToImage.perform_later(image.id)
        return_success("上传成功!后台自动渲染图片!")
    else
        return_error("用户没有权限",1002)
    end
  end
end
