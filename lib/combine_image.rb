class CombineImage
	DEFAULT = {
		outfile: 'result.png',
    out_directory: Rails.root.to_s+"/public",
		position: 'right',
		qrcode_width: 200,
		qrcode_height: 200,
		text_height: 312,
		price: 999.00,
		name: '夏装韩国女生连衣裙学生字母原宿闺蜜装宽松中长直筒短袖',
		introduction:'测试测试测试测试测试测试测试测试测试测试测试测试测试',
		number_char_name:9,
		number_char_introduction: 15,
		padding: 50
	}
	def initialize(product_path,qrcode_path,**option)
		@option = (option.reverse_merge(DEFAULT.deep_dup)).merge({product_path:product_path,qrcode_path:qrcode_path}.deep_dup)
		check_path
		@product = MiniMagick::Image.open @option[:product_path]
		@qrcode = MiniMagick::Image.open @option[:qrcode_path]
		check_product_size
		set_canvas_size
		check_qrcode_size
	end

	def check_product_size
			if @product.width < 550 || @product.width > 650
					@product.resize("600")
					@product.write(@product.path)
			end
	end

	def set_canvas_size
		@canvas_width = @option[:canvas_width] || @product.width
		@canvas_height = @option[:canvas_height] || (@product.height+@option[:text_height]*2)
	end

	def check_qrcode_size
		if @qrcode.width != @option[:qrcpde_width] || @qrcode.height != @option[:qrcode_height]
			@qrcode.resize "#{@option[:qrcpde_width]}X#{@option[:qrcode_height]}"
		end
	end

	def combine
    # [@product.path,@qrcode.path,@option[:outfile]].map!{|path| @option[:out_directory]+path}
		operate(@product.path,@qrcode.path,@option[:outfile])
	end

  def check_path
		@option[:out_directory].chop! if @option[:out_directory][-1] == '/'
	  [@option[:qrcode_path],@option[:product_path],@option[:outfile]].each do |a|
      	a.insert(0,'/') if a[0] != '/'
				a.insert(0,@option[:out_directory])
	  end
  end
	def operate(*path)
		check_output_path
		if path.size == 3
	 		MiniMagick::Tool::Convert.new do |convert|
				convert << '-size'
				convert << "#{@canvas_width}X#{@canvas_height}"
				convert << '-strip'
				convert << 'xc:none'

				convert << '-transparent'
				convert << 'white'
				convert << '-font'
				convert << "#{@option[:out_directory]}/my_font.ttf"

				convert << "-pointsize"
				convert << "38"
				convert << "label:#{get_name}"
				convert << '-geometry'
				convert << "+#{@option[:padding]}+#{@option[:padding]*2}"
				convert << '-composite'

				convert << "-pointsize"
				convert << "48"
				convert << "-fill"
				convert << 'orange'
				convert << "label:$#{@option[:price]}"
				convert << '-geometry'
				convert << "+#{@option[:padding]}+#{(@option[:text_height]-@option[:qrcode_height])/2+@option[:qrcode_height]}"
				convert << '-composite'

				convert << '-fill'
				convert << 'black'
				convert << '-pointsize'
				convert << '32'
				convert << 'label:详情及购买'
				convert << '-geometry'
				convert << "+#{@canvas_width-@option[:qrcode_width]}+#{(@option[:text_height]-@option[:qrcode_height])/2+@option[:qrcode_height]}"
				convert << '-composite'

						
				convert << '-fill'	
				convert << 'black'
				convert << '-pointsize'	
				convert << '32'
				convert << "label:#{get_introduction}"
				convert << '-geometry'
				convert << "+#{@option[:padding]}+#{@option[:text_height]+@product.height}"
				convert << '-composite'
	
				convert <<  path[0]
				convert << '-geometry'
				convert << original_image_position
				convert << '-composite'
				convert << path[1]
				convert << '-geometry'
				convert << get_qrcode_position
				convert << '-composite'
			
				convert << path[2]
			end
		else
			puts 'size of path is wrong!'
		end
	end

	def check_output_path
		dirname = File.dirname @option[:outfile]
		system "mkdir -p #{dirname}"
	end

	def get_name
		insert_char(@option[:name].dup,@option[:number_char_name],3)	
	end

	def insert_char(text,number,line=10)
		text.length > (number*line) && text = text[0...number]
		line.times.each do |index|
			position = number*(index+1)+index*2
			text.insert(position,'\n') if text.length > position
		end
		text
	end

	def get_introduction
		insert_char(@option[:introduction].dup,@option[:number_char_introduction])	
	end
	def original_image_position
	    "+0+#{@option[:text_height]}"
	end
	def get_qrcode_position
		case @option[:position]
		when 'left'
			result = "+0+"
		when 'right'
			result = "+#{@canvas_width-@option[:qrcode_width]}+"
		when 'center'
			result = "+#{(@canvas_width-@option[:qrcode_width])/2}+"
		else
			result = "+0+"
		end
		result + ((@option[:text_height]-@option[:qrcode_height])/2).to_s
	end
end
