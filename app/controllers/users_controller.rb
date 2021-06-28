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
      session[:param] = params[:e]
    end
   
    # GET /users/1/edit
    def edit; end
  
    # POST /users or /users.json
    def create
        # saveしてからじゃないと無理説
      @user = User.new(user_params)
      event=Event.find(session[:param])
      @user.events<<event
    #   @user=event.users.build(user_params)
    #   @user = User.new(user_params)
    #   @user.save
    #   events=Event.find(session[:param])
    #   @user.events.create(id: events.id)
    #   events=Event.find(session[:param])
    #   event.users.new(id:@user.id)
    #   @user.events.new(id: event.id)
     #  byebug
    #   superEve.users.build(id: @user.id)
#      @event=@user.events(superEve)
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
  