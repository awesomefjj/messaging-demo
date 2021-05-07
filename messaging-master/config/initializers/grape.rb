require 'grape-swagger-rails'

if Rails.env.development?
  ActiveSupport::Dependencies.explicitly_unloadable_constants << 'API'
  api_files = Dir[Rails.root.join('app', 'api', '**', '*.rb')]
  api_reloader = ActiveSupport::FileUpdateChecker.new(api_files) do
    Rails.application.reload_routes!
  end
  ActiveSupport::Reloader.to_prepare do
    api_reloader.execute_if_updated
  end
end

GrapeSwaggerRails.options.app_name = 'TM API'
GrapeSwaggerRails.options.url      = '/api/swagger_doc.json'
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
GrapeSwaggerRails.options.api_auth     = 'bearer'
GrapeSwaggerRails.options.api_key_name = 'Authorization'
GrapeSwaggerRails.options.api_key_type = 'header'
