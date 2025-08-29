class User < ApplicationRecord
  has_many :chat_room_users
  has_many :chat_rooms, through: :chat_room_users
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

  # validates :uid, uniqueness: true, allow_nil: true
  validates :name, presence: true

  enum :matching_status, { unmatched: 0, waiting: 1, matched: 2 }

  mount_uploader :profile_image, ProfileImageUploader

  CHATBOT_DAILY_LIMIT = 10

  def reset_chatbot_counter_if_new_day!
    return if chatbot_messages_count_on == Date.current
    # 当日初回アクセス → カウンタを0にして日付を更新
    update_columns(
      chatbot_messages_count: 0,
      chatbot_messages_count_on: Date.current
    )
  end

  def chatbot_remaining
    reset_chatbot_counter_if_new_day!
    [ CHATBOT_DAILY_LIMIT - chatbot_messages_count, 0 ].max
  end

  def can_send_chatbot_message?
    reset_chatbot_counter_if_new_day!
    chatbot_messages_count < CHATBOT_DAILY_LIMIT
  end

  def incr_chatbot_message_count!
    reset_chatbot_counter_if_new_day!
    update_columns(chatbot_messages_count: chatbot_messages_count + 1)
  end

  def self.from_omniauth(auth)
    provider = auth.provider
    uid      = auth.uid
    email    = auth.info.email

    # Googleからの見た目名（プロフィール名など）
    oauth_display_name =
      auth.info.name.presence ||
      auth.info.nickname.presence

    # name へ入れるためのフォールバック（必須バリデーション回避用）
    derived_name =
      oauth_display_name.presence ||
      (email.present? ? email.split("@").first : "user_#{SecureRandom.hex(4)}")

    # 1) すでに provider+uid で紐づいている
    user = find_by(provider: provider, uid: uid)
    return user if user

    # 2) email が一致する既存ユーザーを自動リンク
    user = find_by(email: email)
    if user
      # name が空ならフォールバックを入れてバリデーション通過
      user.update!(
        provider:     provider,
        uid:          uid,
        name:         user.name.presence || derived_name,
        google_name:  oauth_display_name
      )
      return user
    end

    # 3) 見つからない → 新規作成
    create!(
      email:       email,
      provider:    provider,
      uid:         uid,
      name:        derived_name,      # ← バリデーション対策
      google_name: oauth_display_name,
      password:    Devise.friendly_token[0, 20]
    )
  end

  def matched?
    self.matching_status == "matched"
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
