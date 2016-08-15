class Page::OrdersController < Page::ApplicationController
	layout false

	def create
		
	end
	
	def create_by_authorize
		current_member.update_attributes(phone:params[:phone],wechat_number:params[:wechat_number],realname:params[:realname])
		order = Order.create()
	end
end
