# encoding: utf-8
class ImageItemUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # resize_to_limit: resizes to width and height (regardless of aspect ratio)
  #                  only if image is smaller than the limits
  # resize_to_fill:  resize the image to fit within the specified dimensions
  #                  while retaining the aspect ratio of the original image.
  #                  If necessary, crop the image in the larger dimension.

  version :thumb, from: :cover_standard do
    process resize_to_fit: [60, 45]
  end

  version :cover_standard, from: :natural do
    process resize_to_fill:  [170, 127]
  end

  version :cover_big, from: :natural do
    process resize_to_fit: [350, 262]
  end

  version :natural do
    process resize_to_limit: [1200, 800]
  end
end
