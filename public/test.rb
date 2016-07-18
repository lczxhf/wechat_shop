require 'rubygems'
require 'mini_magick'

MiniMagick::Tool::Convert.new do |convert| 

	convert  << "result.png"
	convert << '-transparent'
	convert << 'white'
	convert << '-fill'
	convert << 'black'
	convert << '-font'
	convert << '/Users/lzh/wechat_shop/public/my_font.ttf'
	convert << '-pointsize'
	convert << '32'
	convert << 'label:详情及购买'
	convert << '-geometry'
	convert << '+410+256'
	convert << '-composite'

	convert << 'label:夏装韩国女生连衣裙学生字母原宿\n夏装韩国女生连衣裙学生字母原宿'
	convert << '-geometry'
	convert << '+50+912'
	convert << '-composite'
	
	convert << "-pointsize"
	convert << "38"
	convert << 'label:夏装韩国女生连衣裙\n学生字母原宿闺蜜装\n宽松中长直筒短袖'
	convert << '-geometry'
	convert << '+50+100'
	convert << '-composite'
	
	convert << "-pointsize"
	convert << "48"
	convert << "-fill"
	convert << 'orange'
	convert << 'label:$255.00'
	convert << '-geometry'
	convert << '+50+256'
	convert << '-composite'

	convert << 'result1.png'
end
