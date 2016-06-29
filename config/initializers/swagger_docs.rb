Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public",
    # the URL base path to your API
    :base_path => "http://ads.sensetime.com",
    :controller_base_path => "",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # Ability to setup base controller for each api version. Api::V1::SomeController for example.
    :parent_controller => Api::V1::ApplicationController,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
	"version" => "1.0",
        "title" => "wechat_sensetime",
        "description" => "This is a docs of api.",
        "termsOfService" => "http://ads.sensetime.com/",
        "contact" => {
	  "email" => "linzihao@sensetime.com"
	},
	"license":{
	  "name": "NGINX",
	  "url": "http://www.baidu.com"
	}
      }
    }
  }
})
