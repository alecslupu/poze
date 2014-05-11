class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

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

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create({
        # :username => auth.extra.raw_info.nickname,
        :name => auth.extra.raw_info.name,
        :email => auth.info.email,
        :password => Devise.friendly_token[0,20]
      })
      user.provider = auth.provider
      user.uid  = auth.uid
      user.skip_confirmation!
      user.save
    end
    user
  end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create({
        :username =>  auth.extra.raw_info.username,
        :name => auth.extra.raw_info.name,
        :email => auth.info.email,
        :password => Devise.friendly_token[0,20]
      })
      user.provider = auth.provider
      user.uid  = auth.uid
      user.skip_confirmation!

      user.save!
    end
    user
  end

end
