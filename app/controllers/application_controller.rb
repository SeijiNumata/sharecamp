# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user
    user_id = cookies.signed[:user_id]
    @current_user ||= User.find_by(id: user_id)
  end

  helper_method :current_user
end
