class Picture < ActiveRecord::Base
  belongs_to :user

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :recent, lambda { order("#{self.table_name}.id DESC") }

  mount_uploader :image, PictureUploader

  include Rails.application.routes.url_helpers

   def to_jq_upload
    {
      "name" => name,
      "size" => image.size,
      "url" => image.large.url,
      "thumbnailUrl" => image.thumb.url,
      "deleteUrl" => id,
      "picture_id" => id,
      "deleteType" => "DELETE"
    }
  end
end
