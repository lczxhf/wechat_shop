class Page::MembersController < Page::ApplicationController
	layout false
	def new
	    @member = Member.new
	end
end
