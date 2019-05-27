require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],                        # required unless using use_iam_profile
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],                        # required unless using use_iam_profile
      region:                'eu-central-1'                  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'instazrv'
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
