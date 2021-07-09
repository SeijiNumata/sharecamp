# frozen_string_literal: true

class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]
   
    def index
      @users = User.all
    end
  
    # GET /users/1 or /users/1.json
    def show
    end
  
    # GET /users/new
    def new      
      @user = User.new
      if params[:e] # 新規作成時
      session[:param] = params[:e] 
      elsif session[:event_id] #event_showから
        session[:param] = session[:event_id] 
      end
     
      if session[:param]
          @event=Event.find(session[:param])
      end
    
    end
   
    # GET /users/1/edit
    def edit; end
  
    # POST /users or /users.json
    def create
      @user = User.new(user_params)
      event=Event.find(session[:param])
      if event.users.find_by(name: @user.name)
        @user=event.users.find_by(name: @user.name)
        cookies.signed[:user_id] = @user.id
        @user=event.users.find_by(name: @user.name)

        redirect_to event
      else

      @user.events<<event
      respond_to do |format|
        if @user.save
          cookies.signed[:user_id] = @user.id
          format.html { redirect_to event, notice: 'user was successfully created.' }
        #   format.json { render :show, status: :created, location: @event }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
    end
  
    # PATCH/PUT /users/1 or /users/1.json
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
  
    # DELETE /users/1 or /users/1.json
    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'user was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name)
    end
  end
  