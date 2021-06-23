module Api
    class ItemsController < ApplicationController
      skip_before_action :verify_authenticity_token
  
      def index
        @items = Item.order('created_at DESC')
      end
  
      def create
        @item = Item.new(item_params)
  
        if @item.save
          render json: @item, status: :created
        else
          render json: @item.errors, status: :unprocessable_entity
        end
      end
  
      def destroy
        Item.find(params[:id]).destroy!
      end
  
      def update
        Item.find(params[:id]).toggle!(:is_done)
      end
  
      private 
      def item_params
        params.require(:item).permit(:events_id, :name, :need_number)
      end
    end
  end
  