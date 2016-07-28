class Page::ProductsController < Page::ApplicationController
  layout false
  def index
  	 @products = Product.includes(:qrcode_images).where(member_id:current_member.id)
  end

  def create
     #check_file :upload, required: true, max_size: 1024, file_type: %w(jpg jpeg png)
    if current_member.has_authority?
		product = nil
        ActiveRecord::Base.transaction do
          product = Product.create!(member_id:current_member.id,user_id:current_member.user_id,mark:params[:mark],stock:params[:stock],introduction:params[:introduction],postage:params[:postage],price:params[:price],cost:params[:cost],name:params[:name],is_threshold:params[:is_threshold],status:0)
          3.times.each do |index|
              LevelDistribution.create!(product:product,cost:params[((index+1).to_s+"_cost").to_sym].to_i/100,level:index+1)
          end
          params[:file].each_with_index do |upload,index|
            Image.create!(product_id:product.id,member_id:current_member.id,path:upload,introduction:params[:img_info][index])
          end
        end
        AddQrcodeToImageJob.perform_later(product.id,current_member.id,params[:appid])
        return_success(product.id)
    else
        return_error("用户没有权限",1002)
    end
  end

  def new

  end

  def show
    @product = Product.includes(:images).find params[:id]
    if params[:tag]
        @member = Member.find(QrcodeImage.fetch_cache(tag:params[:tag]).member_id)
    else
        @member = @product.member
    end
	check_member
  end

  private

  def check_member
  		if @member == current_member
			@can_show = 3
		elsif MemberRelation.exists?(parent_member_id:@member.id,child_member_id:current_member.id)
			@can_show = 2
		else
			@can_show = 1
		end
		puts @can_show
  end
end
