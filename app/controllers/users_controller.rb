# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new

    session[:event_id] = params[:e] if params[:e]
    if session[:event_id].nil?
      redirect_to '/'
    else
      @event = Event.find(session[:event_id])
    end
  end

  def create
    event = Event.find(session[:event_id])
    if event.users.find_by(user_params)
      @user = event.users.find_by(user_params)
      cookies.signed[:user_id] = @user.id
    else
      @user = User.new(user_params)
      @user.events << event
    end

    respond_to do |format|
      if @user.save
        cookies.signed[:user_id] = @user.id
        format.html { redirect_to event }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def event_check
    return unless session[:event_id].nil?

    redirect_to '/events'
  end
end
