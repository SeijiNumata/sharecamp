module SessionsHelper

    # 渡されたユーザーでログインする
    def log_in(user)
      session[:user_id] = user.id
    end
  
    # ユーザーのセッションを永続的にする
    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
    end
  
    # 現在ログインしているユーザーを返す（いる場合）
    def current_user
        session[:user_id]
    end
  
    # ユーザーがログインしていればtrue、その他ならfalseを返す
    def logged_in?
      !current_user.nil?
    end
  
    # 現在のユーザーをログアウトする
    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
  end

