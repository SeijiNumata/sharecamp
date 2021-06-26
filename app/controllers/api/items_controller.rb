# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      @items = Item.order('created_at DESC')
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        item_params[:name].count.times do |i|
          @item = Item.new
          @item.name = item_params[:name][i]
          @item.need_number = item_params[:need_number][i]
          @item.events_id=@event.id
          unless @item.save
             render json: @item.errors, status: :unprocessable_entity
            # render json: { status: 'ERROR', data: @item.errors }
            return
          end
        end
      else
        render json: @event.errors, status: :unprocessable_entity
        return
      end

      
      #render json: { status: 'SUCCESS', data: @item }
      render json: @item, status: :created
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
      params.require(:item).permit(:events_id, need_number: [], name: [])
    end

    def event_params
      params.require(:event).permit(:name)
    end

    def set_item
      @item = Item.find(params[:id])
    end
  end
end
