class AddQrcodeToImageJob < ApplicationJob
  queue_as :default

  def perform(product_id,member_id)
      @product = Product.includes(:images).find(product_id) rescue nil
      if @product
        @qrcode_name = "#{member_id}-#{@product.id}"
        @qrcode_ext = ".png"
        qrcode_url = generate_qrcode(product_id,member_id)
        @product.images.each do |image|
          generate_qrcode_image(qrcode_url,image.id,member_id)
        end
      end
  end

  def generate_qrcode(product_id,member_id)
    url = Settings.website_url+"/page/qrcode_images/#{member_id}-#{product_id}"
    qr=RQRCode::QRCode.new(url,:size=>14,:level=>:h).to_img
    qr.resize(200, 200).save(Rails.root.join("public","qrcode",@qrcode_name+@qrcode_ext))
    return "qrcode/#{@qrcode_name}#{@qrcode_ext}"
  end

  def generate_qrcode_image(qrcode_url,image_id)
    qrcode_image = QrcodeImage.create(image_id:image_id,member_id:member_id,product_id:@product.id)
    filename = Digest::MD5.hexdigest(@qrcode_name)+@qrcode_ext
    store_dir = "/uploads/qrcode_image/#{qrcode_image.id}/"
    ActiveRecord::Base.connection.execute("update qrcode_images set path='#{filename}' where id = #{qrcode_image.id}")
    CombineImage.new(@image.path.url,qrcode_url,outfile: store_dir+filename).combine
  end
end
