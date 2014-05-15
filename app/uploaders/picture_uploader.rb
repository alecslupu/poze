# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  #https://gist.github.com/jcsrb/1510601

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir
  process :fix_exif_rotation
  process :exif_info


  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  version :original do

  end

  version :large do
    process :resize_and_pad => [612, 612]
    process :convert => 'jpg'
    process :watermark
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{model.created_at.strftime('%Y/%m/%d')}/#{model.id}"
    end
  end
  version :normal do
    process :resize_and_pad => [225,210]
    process :convert => 'jpg'
    process :watermark
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{model.created_at.strftime('%Y/%m/%d')}/#{model.id}"
    end
  end
  version :thumb do
    process :resize_and_pad => [80,80]
    process :convert => 'jpg'
    process :watermark
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{model.created_at.strftime('%Y/%m/%d')}/#{model.id}"
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      @name ||= "#{Digest::MD5.hexdigest(original_filename)}#{File.extname(original_filename)}"
    end
  end



  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{Rails.root}/uploads/#{model.class.to_s.underscore}/#{model.created_at.strftime('%Y/%m/%d')}/#{model.id}"
  end

  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end

  def delete_tmp_dir(new_file)
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(File.join(cache_dir, @cache_id_was))
    end
  end


  def exif_info
    if (@file)
      self.model.exif_info = ::Magick::Image::read(@file.file).first
    end
  end

end
