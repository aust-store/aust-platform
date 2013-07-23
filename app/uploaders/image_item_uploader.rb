# encoding: utf-8
class ImageItemUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb, from: :cover_standard do
    process resize_to_fit: [60, 45]
  end

  version :medium do
    process resize_to_limit: [170, 127]
  end

  version :cover_standard, from: :cover_big do
    process resize_to_limit:  [170, 127]
  end

  version :cover_big, from: :natural do
    process resize_to_limit: [350, 262]
  end

  version :natural do
    process resize_to_limit: [1200, 800]
  end
end
