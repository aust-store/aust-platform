RAILS_ENV    = ENV['RAILS_ENV'] || 'development'

require 'yaml'
config_file = File.expand_path('../../config.yml',  __FILE__)
config = YAML.load_file(config_file)[RAILS_ENV]

Backup::Model.new(:uploads_backup, 'Backup uploads to S3') do

  archive :uploads do |archive|
    archive.add "public/uploads"
  end

  store_with S3 do |s3|
    s3.access_key_id      = config['s3']['key_id']
    s3.secret_access_key  = config['s3']['secret_access_key']
    s3.region             = 'us-east-1'
    s3.bucket             = 'austprodbackup'
    s3.path               = 'uploads'
    s3.keep               = 5
  end

  compress_with Gzip do |compression|
    compression.best = true
    compression.fast = false
  end

end
