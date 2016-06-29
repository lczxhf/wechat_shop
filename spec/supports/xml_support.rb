module XmlSupport
	require 'roxml'
	extend ActiveSupport::Concern
	included do
		def generate_wechat_xml(appid,content)
			message  = XmlEncryptMessage.new
			message.AppId = appid
			message.Encrypt = ThirdParty.encrypt(content)
			message.to_xml
		end
	end

	class XmlEncryptMessage
		include ROXML
		xml_name :xml
    		xml_accessor :AppId, :cdata   => true
   		xml_accessor :Encrypt, :cdata => true

   		def to_xml
      		super.to_xml(:encoding => 'UTF-8', :indent => 0, :save_with => 0)
    	end
	end

	class XmlBaseMessage
		include ROXML
		xml_name :xml
		xml_accessor :AppId, :cdata   => true
		xml_reader   :CreateTime, :as => Integer
		xml_accessor :InfoType, :cdata   => true	

		def to_xml
      		super.to_xml(:encoding => 'UTF-8', :indent => 0, :save_with => 0)
    	end	
	end

	class XmlTicketMessage < XmlBaseMessage
		xml_accessor :ComponentVerifyTicket, :cdata   => true
	end

	class XmlUnauthorizeMessage < XmlBaseMessage
		xml_accessor :AuthorizerAppid, :cdata   => true
	end
end
