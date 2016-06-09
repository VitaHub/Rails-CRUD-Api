ActiveModel::Serializer.setup do |config|
	config.adapter = :json
	config.jsonapi_include_toplevel_object = true
	config.jsonapi_version = true
end