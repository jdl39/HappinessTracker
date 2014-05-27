OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1458365944407016', '0c14d71f25fda6088a20f0ee74880fb9'
end
