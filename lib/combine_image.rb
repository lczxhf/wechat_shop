class CombineImage
	DEFAULT = {
		outfile: 'result.png',
    out_directory: Rails.root.to_s+"/public",
		position: 'center',
		qrcode_width: 200,
		qrcode_height: 200
	}
	def initialize(product,qrcode,**option)
		@product = MiniMagick::Image.new product
		@qrcode = MiniMagick::Image.new qrcode
		@option = option.merge(DEFAULT)
		set_canvas_size
		check_qrcode_size
	end

	def set_canvas_size
		@canvas_width = @option[:canvas_width] || @product.width
		@canvas_height = @option[:canvas_height] || (@product.height+@option[:qrcode_height])
	end

	def check_qrcode_size
		if @qrcode.width != @option[:qrcpde_width] || @qrcode.height != @option[:qrcode_height]
			@qrcode.resize "#{@option[:qrcpde_width]}X#{@option[:qrcode_height]}"
		end
	end

	def combine
    check_path
    [@product.path,@qrcode.path,@option[:outfile]].map!{|path| @option[:out_directory]+path}
		operate(@product.path,@qrcode.path,@option[:outfile])
	end

  def check_path
      @option[:outfile].insert(0,'/') if @option[:outfile][0] != '/'
      @option[:out_directory].chop! if @option[:out_directory][-1] == '/'
  end
	def operate(*path)
		if path.size == 3
	 		MiniMagick::Tool::Convert.new do |convert|
				convert << '-size'
				convert << "#{@canvas_width}X#{@canvas_height}"
				convert << '-strip'
				convert << 'xc:none'
				convert <<  path[0]
				convert << '-geometry'
				convert << '+0+0'
				convert << '-composite'
				convert << path[1]
				convert << '-geometry'
				convert << get_qrcode_position
				convert << '-composite'
				convert << path[2]
			end
			puts 'success'
		else
			puts 'size of path is wrong!'
		end
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
		result + (@canvas_height-@option[:qrcode_height]).to_s
	end
end
