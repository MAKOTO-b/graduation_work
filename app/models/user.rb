class User < ApplicationRecord
  has_many :chat_room_users
  has_many :chat_rooms, through: :chat_room_users
  has_many :chat_messages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def update_without_current_password(params, *options)

    #パスワードとパスワードの確認のフォームが空のときにtrueを返す
    if params[:password].blank? && params[:password_confirmation].blank?
      #passwordとpassword_confirmationのパラメータを削除
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

end
