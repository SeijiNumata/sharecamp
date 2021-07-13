# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      item_params_id
      set_item
    end

    def new
      @event = Event.new
    end

    def create
      # @event = Event.new(event_params)
      # if @event.save
      #   item_params[:name].count.times do |i|
      #     @item = Item.new
      #     @item.name = item_params[:name][i]
      #     @item.need_number = item_params[:need_number][i]
      #     @item.event_id = @event.id
      #     render json: { status: 'ERROR', data: @item.errors } unless @item.save
      #   end
      # #  session[:fromCreate] = 'fromCreate'
      #   session[:event_id] = @event.id
      #   render json: @event, status: :created
      # else
      #   render json: { status: 'ERROR', data: @event.errors }
      # end
    end

    def destroy
      set_item
      if @item.destroy!
        head :ok
      else
        head :bad_request
      end
    end

    private

    def item_params
      params.require(:item).permit(:event_id, need_number: [], name: [])
    end

    def item_params_id
      params.permit(:id)
    end

    def event_params
      params.require(:event).permit(:name)
    end

    def set_item
      @item = Item.find(params[:id])
    end
  end
end
