 
class NoisyImage
	include MiniMagick
	attr_reader :code,:image  
	Jiggle = 15
	Wobble = 15
	
	def initialize(len = 4)
		puts self.methods.inspect
		chars = ('a'..'z').to_a + ('0'..'9').to_a
		rand_chars = []
		1.upto(len) {rand_chars.push(chars[rand(chars.length)])}

		background_type ="granite:"
		background = Image.new(background_type)
		canvas = Image.new
		canvas.new_image(32*len, 30, Tool::TextureFill.new(background))
		gc = Tool::Draw.new 
		gc.font_family = 'times'
		gc.pointsize = 20
		cur = 10
		rand_chars.each{|c|
			gc.annotate(canvas, 0, 0, cur, 15+rand(Jiggle), c){
				self.rotation = rand(10) > 5 ? rand(Wobble) : -rand(Wobble)
				self.font_weight = rand(10) > 5 ? NormalWeight : BoldWeight
				self.fill = 'black'
			}
			cur += 30
		}

		@code = rand_chars.to_s
		@image = canvas.to_blob{
			self.format="JPG"
		}
	end
end
