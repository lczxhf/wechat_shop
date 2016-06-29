# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	#identified_by :current_user_id
  	# def connect
   #    self.current_user_id = find_verified_user_id
   #  end

   #  protected
   #    def find_verified_user_id
   #      cookies.signed[:user_id] || nil #reject_unauthorized_connection
   #    end
  end
end
