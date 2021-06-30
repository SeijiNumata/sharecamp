# frozen_string_literal: true

class ApplicationController < ActionController::Base
    def current_user
        # if (user_id = session[:user_id])
        #     byebug
        #     @current_user ||= User.find_by(id: user_id)
        #   elsif (user_id = cookies.signed[:user_id])
        #     byebug
        #     user = User.find_by(id: user_id)     
        #       session[:user_id] = user.id
        #       @current_user = user
        #     end
        user_id = cookies.signed[:user_id]
        user = User.find_by(id: user_id) 
        user    
    end
end
