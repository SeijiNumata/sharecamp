# frozen_string_literal: true

module EventsHelper
  def current_user_test(user_id)
    user_id = cookies.signed[:user_id]
    User.find_by(id: user_id)
  end
end
