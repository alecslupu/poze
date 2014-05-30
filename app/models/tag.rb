class Tag < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :taggings
  has_many :pictures, through: :taggings
end
