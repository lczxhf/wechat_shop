require 'rails_helper'

RSpec.describe ThirdParty::WechatController, type: :controller do
	context '#home' do
		let(:shop) {create(:shop)}

		it 'should success' do
			get :home,params: {id: shop.id}
			expect(response).to be_success
			expect(response.body).to match("component_appid")
		end

		it "should success if shop expire" do
			shop.expire!
			get :home,params: {id: shop.id}
			expect(response).to be_success
			expect(response.body).to match(I18n.t("returnCode.code_1002"))
		end

		it "should failure if user doesn't exist" do
			get :home,params:{id: rand(2..10)}
			expect(response).to be_success
			expect(response.body).to match(I18n.t("returnCode.code_1001"))
		end
	end
end
