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
        @item.destroy!
      end
  
      def update
        if @item.update(item_params)
            head :ok
          else
            head :bad_request
          end
      end
  
      private 
      def item_params
        params.require(:item).permit(:events_id, :name, :need_number)
      end

      def set_item
        @item = Item.find(params[:id])
      end
      
    end
  end
  