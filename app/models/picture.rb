class Picture < ActiveRecord::Base
  belongs_to :user

  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :image, PictureUploader
end
