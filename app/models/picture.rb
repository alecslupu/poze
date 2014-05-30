class Picture < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings


  extend FriendlyId
  friendly_id :name, use: :slugged


  mount_uploader :image, PictureUploader

  scope :recent, lambda { order("#{self.table_name}.id DESC") }


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

  #++++++++++

  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.pluck(:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

end
