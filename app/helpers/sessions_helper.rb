# frozen_string_literal: true

module SessionsHelper
  def current_user
    user_id = cookies.signed[:user_id]
    @current_user ||= User.find_by(id: user_id)
  end
end
