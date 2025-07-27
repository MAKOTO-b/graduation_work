class User < ApplicationRecord
  has_many :chat_room_users
  has_many :chat_rooms, through: :chat_room_users
  has_many :chat_messages
  has_many :rmd_chat_room_users
  has_many :rmd_chat_rooms, through: :rmd_chat_room_users
  has_many :rmd_chat_messages
  has_many :grumbles, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :uid, uniqueness: true, allow_nil: true
  validates :name, presence: true

  mount_uploader :profile_image, ProfileImageUploader

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      user.avatar = auth.info.image
      user.skip_confirmation!
    end
  end

  def liked?(grumble)
  likes.exists?(grumble_id: grumble.id)
  end

  def update_without_current_password(params, *options)
    # パスワードとパスワードの確認のフォームが空のときにtrueを返す  z
    if params[:password].blank? && params[:password_confirmation].blank?
      # passwordとpassword_confirmationのパラメータを削除
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end
end
