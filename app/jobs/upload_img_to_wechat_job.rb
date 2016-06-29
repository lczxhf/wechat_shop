class UploadImgToWechatJob < ApplicationJob
  queue_as :default

  def perform(record_id)
	ScanRecord.find(record_id).upload_media
  end
end
