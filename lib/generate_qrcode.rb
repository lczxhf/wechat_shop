class GenerateQrcode
	def self.generate(url,path,level='h')
		FileUtils.mkdir_p(path[0...path.rindex("/")])
		qrcode = RQRCode::QRCode.new(url,:size=>14,:level=>level).to_img.resize(200,200)
		qrcode.save(path) 
	end
end
