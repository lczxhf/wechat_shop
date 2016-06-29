require 'rails_helper'

RSpec.describe Api::V1::Fashion::WeixinController, type: :controller do
	context '#upload' do
		let(:shop) {create(:shop)}


		it 'should  success' do
			post :upload, params: {shop_id: shop.id, randCode:SecureRandom.hex,upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(200)
		end

		it 'should  failure if lack of image' do
			post :upload, params: {shop_id: shop.id, randCode:SecureRandom.hex}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1001)
		end

		it 'should  failure if lack of shop_id' do
			post :upload, params: {randCode:SecureRandom.hex,upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1001)
		end

		it 'should  failure if lack of randCode' do
			post :upload, params: {shop_id: shop.id,upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1001)
		end

		it 'should  failure if mime type of image invalid' do
			post :upload, params: {shop_id: shop.id, randCode:SecureRandom.hex,upload:fixture_file_upload("subscribe.png",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1004)
		end

		it 'should  failure if size of image out of limit' do
			pending "add some examples to (or delete) #{__FILE__}"
		end


		it 'should add a new scan_record' do
			UploadImgToWechatJob.stub(:perform_later)
			post :upload, params: {shop_id: shop.id, randCode:SecureRandom.hex,upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(ScanRecord.count).to eq(1)
		end
	end

	context '#upload_without_randcode' do
		let(:shop) {create(:shop)}


		it 'should  success' do
			post :upload_without_randcode, params: {shop_id: shop.id,upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(200)
		end

		it 'should  failure if lack of image' do
			post :upload_without_randcode, params: {shop_id: shop.id}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1001)
		end

		it 'should  failure if lack of shop_id' do
			post :upload_without_randcode, params: {upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1001)
		end


		it 'should  failure if mime type of image invalid' do
			post :upload_without_randcode, params: {shop_id: shop.id,upload:fixture_file_upload("subscribe.png",'image/png')}
			expect(response).to be_success
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1004)
		end

		it 'should  failure if size of image out of limit' do
			pending "add some examples to (or delete) #{__FILE__}"
		end


		it 'should add a new scan_record' do
			UploadImgToWechatJob.stub(:perform_later)
			post :upload_without_randcode, params: {shop_id: shop.id,upload:fixture_file_upload("test.jpg",'image/png')}
			expect(response).to be_success
			expect(ScanRecord.count).to eq(1)
		end
	end
end
