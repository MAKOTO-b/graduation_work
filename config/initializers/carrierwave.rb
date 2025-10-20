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
    config.fog_public    = true  # 公開URLで配信（簡単）。非公開にしたい場合は false に。
  else
    config.storage = :file
    config.enable_processing = !Rails.env.test?
  end
end