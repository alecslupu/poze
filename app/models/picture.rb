class Picture < ActiveRecord::Base
  belongs_to :user

  extend FriendlyId
  friendly_id :name, use: :slugged


  mount_uploader :image, PictureUploader

  include Rails.application.routes.url_helpers

   def to_jq_upload
    {
      "name" => read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "thumbnailUrl" => image.thumb.url,
      "deleteUrl" => id,
      "picture_id" => id,
      "deleteType" => "DELETE"
    }
  end
end
