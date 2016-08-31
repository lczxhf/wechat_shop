class Page::OrdersController < Page::ApplicationController
	layout false

	def create
		
	end
	
	def create_by_authorize
		if params[:code] && params[:code] == Rails.cache.read(params[:phone])
			#Rails.cache.delete(params[:phone])
			current_member.update_attributes(phone:params[:phone],wechat_number:params[:wechat_number],realname:params[:realname])
			share_record = ShareRecord.find(params[:share_record_id])
			if share_record.sent?
				share_record.status = "wait_pay"
				order = Order.new(shop_id:share_record.shop_id,member_id:current_member.id,share_record_id:share_record.id,phone:params[:phone],address:params[:address],is_store:params[:is_store])
				products = Product.find(params[:product_ids]) rescue nil
				if products.present? && params[:product_sum].size == params[:product_ids].size
					total_price = Product.counter_total_price(products,params[:product_sum])
					if total_price >= share_record.price
						order.total_price = total_price
						ActiveRecord::Base.transaction do
							if params[:is_store]=="false" && !products.each_with_index.map{|product,index| product.check_stock(params[:product_sum][index])}.index(false)
								order.save!
								share_record.save!
								products.each_with_index {|product,index| product.generate_order_product(order.id,params[:product_sum][index])}
								return_success('ok')
							elsif params[:is_store] == "true" && !products.each_with_index.map{|product,index| product.check_member_stock(current_member.id,params[:product_sum][index])}.index(false)
								order.save!
								share_record.save!
								products.each_with_index {|product,index| product.generate_order_product(order.id,params[:product_sum][index],{is_store:true,shop_id:share_record.shop_id,member_id:current_member.id})}
								return_success('ok')
							else
								return_error("库存不够")
							end
						end
					else
						return_error("购买的价格没有达到要求")
					end
				else
					return_error("上传的商品id有误")
				end
			else
					return_error("授权已失效")
			end
		else
			return_error('验证码错误')
		end
	end
end
