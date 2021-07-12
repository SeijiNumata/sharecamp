# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
    # if params[:e] # eventの新規作成時はvueからevent_idをもらう
    #   session[:event_id] = params[:e]
    # end

    @event = Event.find(session[:event_id])

  end

  def edit; end

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
        format.html { redirect_to event, notice: 'user was successfully created.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'user was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
