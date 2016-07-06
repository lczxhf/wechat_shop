class Page::ProductsController < Page::ApplicationController
  layout false
  def create
    check_file :upload, required: true, max_size: 1024, file_type: %w(jpg jpeg png)
    if current_member.has_authority?
		product = nil
        ActiveRecord::Base.transaction do
          product = Product.create!(member_id:current_member.id,user_id:current_member.user_id,mark:params[:mark],stock:params[:stock],introduction:params[:introduction],postage:params[:postage],price:params[:price],cost:params[:cost])
          params[:upload].each do |upload|
            Image.create!(product_id:product.id,member_id:current_member.id,path:params[:upload])
          end
        end
        AddQrcodeToImageJob.perform_later(product.id,current_member.id)
        return_success("上传成功!后台自动渲染图片!")
    else
        return_error("用户没有权限",1002)
    end
  end

  def new

  end
end
