class Mybase64
  require 'digest/md5' 
  MYKEY = 'Qxd3efg56F9abvWwBlmEL1GHnopqrSTUVYtyz0AC7DIcuJKhijk2M8sNOPRXZ4/+'
  class << self
	def encodeAuth(text)
		time = Time.now.to_i.to_s
		info = ''
		encode(text.to_s).each_char {|a| info += a.ord.to_s(16)}
		md5 = Digest::MD5.hexdigest("Adam-#{Digest::MD5.hexdigest(info.to_s)}#{time}_authEncode")
		result = info + time + md5
	end

	def encode(text)
		i = 0
		output = ''
		
		while i < text.length do  
			chr1 = chr2 = chr3 = 0 
			enc1 = enc2 = enc3 = enc4 = 0
			chr1 = text[i] ? text[i].ord : 0
			i += 1
			chr2 = text[i] ? text[i].ord : 0
			i += 1
			chr3 = text[i] ? text[i].ord : 0
			i += 1 
			enc1 = chr1 >> 2 if !chr1.nil?
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4) 
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6)	
			enc4 = chr3 & 63 
			# if chr2.nan?
			# 	enc3 = enc4 = @key.length
			# elsif chr3.nan?
			# 	enc4 = @key.length
			# end
			
			output += MYKEY[enc1] + MYKEY[enc2] + MYKEY[enc3]  + MYKEY[enc4] 
		end
		output
	end

	def decodeAuth(text)
		if text.length > 40
			result=''
			pass = text[-32..-1]
			time = text[-42,10]
			info = text[0..-43]

			if pass == Digest::MD5.hexdigest("Adam-#{Digest::MD5.hexdigest(info)}#{time}_authEncode")
					char = ''
					(info.length/2).times do |a|
						char += [info[a*2,2].hex].pack 'U'
					end
					result = decode(char)
			end
		end
		result
	end

	def decode(text)
		result = ''
		bin = ''
		return result if text.length % 4 != 0
		text.each_char do |a|
			break if a == '='
			index = MYKEY.index(a)
			bin += ("000000" + index.to_s(2))[-6..-1]
			#puts bin
			if bin.length >=8 
				dechar = bin[0..7]
				bin = bin[8..-1]
				result += [dechar.to_i(2)].pack 'U'
			end
		end
		result
	end
  end
end
