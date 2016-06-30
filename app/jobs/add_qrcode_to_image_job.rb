class AddQrcodeToImageJob < ApplicationJob
  queue_as :default

  def perform(image_id)
      @image = Image.find image_id rescue nil
      if @image
        @qrcode_name = "#{@image.id}-#{@image.member_id}"
        @qrcode_ext = ".png"
        qrcode_url = generate_qrcode
        generate_qrcode_image(qrcode_url)
      end
  end

  def generate_qrcode
    url = ''
    qr=RQRCode::QRCode.new(url,:size=>14,:level=>:h).to_img
    qr.resize(200, 200).save(Rails.root.join("public","qrcode",@qrcode_name+@qrcode_ext))
    return "qrcode/#{@qrcode_name}#{@qrcode_ext}"
  end

  def generate_qrcode_image(qrcode_url)
    qrcode_image = QrcodeImage.create(image_id:@image.id,member_id:@image.member_id,product_id:@image.product_id)
    filename = Digest::MD5.hexdigest(@qrcode_name)+@qrcode_ext
    store_dir = "/uploads/qrcode_image/#{qrcode_image.id}/"
    ActiveRecord::Base.connection.execute("update qrcode_images set path='#{filename}' where id = #{qrcode_image.id}")

    CombineImage.new(@image.path.url,qrcode_url,outfile: store_dir+filename).combine
  end
end
