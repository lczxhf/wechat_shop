require 'rails_helper'

RSpec.describe GzhConfig, type: :model do
  describe "validate whether save" do
  	pending "add some examples to (or delete) #{__FILE__}"
  end

  describe "method" do
  	let!(:gzh_config) {create(:gzh_config)}
  	
  	context '::generate_config' do
  		let(:json) do
  		JSON.parse(%{{"authorization_info":{"authorizer_appid":"#{gzh_config.appid}","authorizer_access_token":"#{gzh_config.token}","authorizer_refresh_token":"#{gzh_config.refresh_token}"}}})
  		end
  		it "should success" do
  			GzhConfig.all.delete_all
   			GzhConfig.generate_config(json,gzh_config.shop_id)
  			expect(GzhConfig.count).to eq 1
  		end

  		it "should failure if the appid is exist" do
  			expect(GzhConfig.count).to eq 1
  			GzhConfig.generate_config(json,gzh_config.shop_id)
  			expect(GzhConfig.count).to eq 1
  		end
  	end

  	context '#update_gzh_info' do
  		before(:each) do
  			json = JSON.parse(%{{"authorizer_info":{"nick_name":"微信SDK Demo Special","head_img":"http://wx.qlogo.cn/mmopen/GPyw0pGicibl5Eda4GmSSbTguhjg9LZjumHmVjybjiaQXnE9XrXEts6ny9Uv4Fk6hOScWRDibq1fI0WOkSaAjaecNTict3n6EjJaC/0","service_type_info":{"id":2},"verify_type_info":{"id":0},"user_name":"gh_eb5e3a772040","business_info":{"open_store":0,"open_scan":0,"open_pay":0,"open_card":0,"open_shake":0},"alias":"paytest01"},"qrcode_url":"URL","authorization_info":{"appid":"wxf8b4f85f3a794e77","func_info":[{"funcscope_category":{"id":1}},{"funcscope_category":{"id":2}},{"funcscope_category":{"id":3}}]}}}) 
  			#Wechat = double(:Wechat,:get_gzh_info=>json)
        allow(Wechat).to receive(:get_gzh_info) { json }
  			#Wechat.stub(:get_gzh_info).and_return(json)
  		end
  		it "should success" do
  			gzh_config.update_gzh_info
  			expect(GzhInfo.count).to eq 1
  			expect(GzhInfo.first.gzh_config).to eq(gzh_config)
  		end
  		it "should cover if gzh_config instance alreay have gzh_info" do
  			gzh_config.gzh_info = create(:gzh_info)
  			gzh_config.update_gzh_info
  			expect(GzhInfo.count).to eq 1
  			expect(GzhInfo.first.gzh_config_id).to eq(gzh_config.id)
  			expect(GzhInfo.first.user_name).to eq("gh_eb5e3a772040")
  		end
  	end

  	context "refresh_gzh_token" do
  		before(:each) do
  			json = JSON.parse(%{{"authorizer_access_token":"aaUl5s6kAByLwgV0BhXNuIFFUqfrR8vTATsoSHukcIGqJgrc4KmMJ-JlKoC_-NKCLBvuU1cWPv4vDcLN8Z0pn5I45mpATruU0b51hzeT1f8","expires_in":7200,"authorizer_refresh_token":"BstnRqgTJBXb9N2aJq6L5hzfJwP406tpfahQeLNxX0w"}})
  			#ThirdParty = double(:ThirdParty,:refresh_gzh_token=>json)
        allow(ThirdParty).to receive(:refresh_gzh_token) { json }
  		end

  		it "should success" do
  			gzh_config.refresh_gzh_token
  			expect(gzh_config.token).to eq("aaUl5s6kAByLwgV0BhXNuIFFUqfrR8vTATsoSHukcIGqJgrc4KmMJ-JlKoC_-NKCLBvuU1cWPv4vDcLN8Z0pn5I45mpATruU0b51hzeT1f8")
  		end

  		it "should failure if response data is error" do
  			ThirdParty.stub(:refresh_gzh_token).and_return(%{{{"errcode":0,"errmsg":"ok"}}})
  			gzh_config.refresh_gzh_token
  			expect(gzh_config.token_changed?).to eq(false)
  		end
  	end
  end

  context "check token whether expire after find" do
  	 let(:gzh_config) {build(:gzh_config)}
  	 before do
  	 	json = JSON.parse(%{{"authorizer_access_token":"aaUl5s6kAByLwgV0BhXNuIFFUqfrR8vTATsoSHukcIGqJgrc4KmMJ-JlKoC_-NKCLBvuU1cWPv4vDcLN8Z0pn5I45mpATruU0b51hzeT1f8","expires_in":7200,"authorizer_refresh_token":"BstnRqgTJBXb9N2aJq6L5hzfJwP406tpfahQeLNxX0w"}})
  		#ThirdParty = double(:ThirdParty,:refresh_gzh_token=>json)
  		#ThirdParty.stub(:refresh_gzh_token).and_return(json)
      allow(ThirdParty).to receive(:refresh_gzh_token) { json }
  	 end
  	 it 'and refresh toekn automatically if update_at more than 4500 sec' do
  	 	gzh_config.updated_at = Time.now - 2.hour
  	 	gzh_config.save
  	 	expect(GzhConfig.find(gzh_config.id).token).to eq('aaUl5s6kAByLwgV0BhXNuIFFUqfrR8vTATsoSHukcIGqJgrc4KmMJ-JlKoC_-NKCLBvuU1cWPv4vDcLN8Z0pn5I45mpATruU0b51hzeT1f8')
  	 end

  	 it 'and do nothing' do
  	 	gzh_config.save
  	 	expect(GzhConfig.find(gzh_config.id).token).to eq('sensetime')
  	 end
  end

  context 'find by condition where del is false' do
  	 let(:gzh_config) {create(:gzh_config,del:true)}

  	 it 'should success' do
  	 	expect(GzhConfig.all.count).to eq(0)
  	 end

  	 it 'and from other oject indirectly' do
  	 	shop = create(:shop)
  	 	gzh_config.update_attribute(:shop_id,shop.id)
  	 	expect(shop.gzh_config).to be_nil
  	 end
  end

  context 'get record from redis cache' do
  	let(:redis) {Redis.new(:db=>10)}
  	let!(:gzh_config) {create(:gzh_config)}
  	 it 'by id should success' do
  	 	result = redis.exists(gzh_config.second_level_cache_key)
  	 	expect(result).to eq(true)
  	 end

  	 it 'by id should failure if select multi record' do
  	 	create(:gzh_config)
		redis.flushdb()
  	 	gzh_config = GzhConfig.where(token:'sensetime').to_a.first
  	 	result =redis.exists(gzh_config.second_level_cache_key)
  	 	expect(result).to eq(false)
  	 end

  	 it 'by uniq key should success' do
  	 	gzh_config = GzhConfig.fetch_cache(appid:'123456789')
  	 	expect(redis.exists("uniq_key_GzhConfig_appid_123456789")).to eq(true)
  	 end
  end
end

