module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # WebSocket接続が開いている場合は閉じ、404を返す
      reject_unauthorized_connection unless find_verified_user
    end

    private

      def find_verified_user
        # ログインしているユーザー情報取得
        self.current_user = env["warden"].user
      end
  end
end
