# Loading the AWS configuration file located at config/aws.yml
AWS_CONFIG = YAML.load_file("#{Rails.root}/config/aws.yml")[Rails.env]

  require 'aws-sdk-v1'
  require 'aws-sdk'

  # TODO
  # This is not recommended, but to skip verification of SSL certificate in windows platform it is quick fix
  # Need to be fixed soon
  Aws.config[:ssl_verify_peer] = false

  # # Credentials for AWS
  credentials = Aws::Credentials.new(AWS_CONFIG['access_key_id'], AWS_CONFIG['secret_access_key'])

  # Creating S3 Client to access the buckets and objects
  S3_CLIENT = Aws::S3::Client.new(:credentials => credentials, :region => AWS_CONFIG['region'])
  S3_RESOURCE = Aws::S3::Resource.new(:region => AWS_CONFIG['region'])
  $BUCKET = S3_RESOURCE.bucket(AWS_CONFIG['bucket'])