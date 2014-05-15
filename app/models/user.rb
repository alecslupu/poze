class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  mount_uploader :avatar, UserUploader

  def familiar_name
    name.include?(' ') ? name.split(' ').first : name.first(10)
  end

  def to_s
    name ? name : username
  end

  def set_default_role
    self.role ||= :user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.present?
      end
    end
  end

  def self.find_by_oauth(auth)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first_or_initialize
    user.set_oauth_info(auth) if user.new_record?

    user
  end

  def set_oauth_info(auth)
    username = auth.extra.raw_info.username
    name = auth.extra.raw_info.name
    email = auth.info.email
    password = Devise.friendly_token[0,20]
    confirm!
  end

  def confirm!
    skip_confirmation!
    save!
  end
end
