# frozen_string_literal: true

module Api
    class UserBringItemsController < ApplicationController
      skip_before_action :verify_authenticity_token
  
      def index
        @items = Item.order('created_at DESC')
      end
      
      def show
        render json: @event
      end
  
      def new
        @event = Event.new
      end
  
      def create
        bring_number=user_bring_item_params[:selectedNumber]
        user_bring_item=UserBringItem.new(bring_number: bring_number)
        item=Item.find(item_params[:id])
        item.user_bring_items << user_bring_item
        current_user.user_bring_items << user_bring_item
        if user_bring_item.save
          #何かを返す
        else
          render json: { status: 'ERROR', data: user_bring_item.errors }
          # return
        end      
        
        # render json: { status: 'ERROR', data: @item.errors }
        # # format.html { redirect_to @event, notice: 'Event was successfully created.' }
        # # format.json { render json: { status: 'SUCCESS', data: @item }}
        # # #render json: @item, status: :created
        # #  #render json: @item.errors, status: :unprocessable_entity
        # #  render json: { status: 'ERROR', data: @item.errors 
        # render :show, status: :created
        # redirect_to root_path
        # respond_to do |format|
        #     format.html { redirect_to @event, notice: 'Event was successfully created.' }
        #     format.json { render :show, status: :created, location: @event }
        #  end
      end
  
      def destroy
        set_user_bring_item
        @user_bring_item.destroy!
        # @item.destroy!
      end
  
      def update
        byebug
        User.find(params[:id])
        if @item.update(item_params)
          head :ok
        else
          head :bad_request
        end
      end
  
      private
  
      def item_params
        params.require(:item).permit(:id)
      end
      def user_bring_item_params
        params.permit(:selectedNumber)
      end

      def set_user_bring_paras
        #todo
      end



      def event_params
        params.require(:event).permit(:name)
      end
  
      def set_item
        @item = Item.find(params[:id])
      end

      def set_user_bring_item
        @user_bring_item=UserBringItem.find(params[:id])
      end
    end
  end
