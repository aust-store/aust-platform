# encoding: utf-8
class ImageGoodUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_limit: [60,45]
  end

  version :medium do
    process resize_to_limit: [170,127]
  end

  version :cover_standard do
    process resize_to_fill:  [170,127]
  end

  version :big do
    process resize_to_limit: [350,262]
  end
end