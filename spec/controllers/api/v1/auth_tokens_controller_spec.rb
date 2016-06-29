require 'rails_helper'

RSpec.describe Api::V1::AuthTokensController, type: :controller do
	context '#create' do
		let(:shop) {create(:shop)}

		it "should success" do
			post :create,params: {shop_id:shop.id}
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(200)
		end

		it "should failure if shop do not exist" do
			post :create,params: {shop_id:rand(2..10)}
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1001)
		end

		it "should failure if shop was expired" do
			shop.expire!
			post :create,params: {shop_id:shop.id}
			expect(JSON.parse(response.body)[Settings.return_json_status_name]).to eq(1002)
		end
	end
end
