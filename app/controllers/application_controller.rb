# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user
    if cookies.signed[:user_id].nil?
      nil
    else
      user_id = cookies.signed[:user_id]
      User.find_by(id: user_id)
    end
  end
end
