class MediaUploader < CarrierWave::Uploader::Base
	include CarrierWave::MiniMagick
	def store_dir
		"uploads/#{model.class.to_s.underscore}/#{model.id}"
	end

	def default_url
		"/images/default_media.png"
	end

	version :thumb do
		process :resize_to_fit => [200,200]
	end

	def extension_white_list
		%w(jpg jpeg gif png)
	end
end
