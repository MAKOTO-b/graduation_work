require 'fog/aws'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage      = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION'] # 例: ap-northeast-1
    }
    config.fog_directory = ENV['AWS_BUCKET']
    config.fog_public    = true
    # ※ まずは asset_host は設定しない（S3のURLで出るようにする）
  else
    config.storage = :file
    config.enable_processing = !Rails.env.test?
  end
end