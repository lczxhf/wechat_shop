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

	def ext
    file.extension.downcase
  end

	def filename
    if super.present?
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{ext}"
    end
  end
end
