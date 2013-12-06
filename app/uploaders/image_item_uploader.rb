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

  version :thumb do
    process resize_to_fit: [60, 45]
  end

  # small size
  #
  # !important! if you change these sizes, you need to change the
  #             mustache_documentation.yml file
  version :cover_standard, from: :natural do
    process resize_to_fit:  [170, 127]
  end

  # medium size
  #
  # !important! if you change these sizes, you need to change the
  #             mustache_documentation.yml file
  version :cover_big, from: :natural do
    process resize_to_fit: [350, 262]
  end

  version :bigger, from: :natural do
    process resize_to_fit: [700, 524]
  end

  version :natural do
    process resize_to_limit: [1200, 800]
  end
end
