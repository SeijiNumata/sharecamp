# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token
    protect_from_forgery

    def create
      event_name_params
      @event = Event.new(event_params)
      if @event.save

        item_params[:name].count.times do |i|
          next if item_params[:name][i].nil? || item_params[:need_number][i].nil?

          @item = Item.new
          @item.name = item_params[:name][i]
          @item.need_number = item_params[:need_number][i]
          @item.event_id = @event.id
          render json: { status: 'ERROR', data: @item.errors } unless @item.save
        end
      else
        render json: { status: 'ERROR', data: @event.errors }
      end
      session[:fromCreate] = 'fromCreate'
      session[:event_id] = @event.id
      render json: @event, status: :created
   
    end

    def update
      event = Event.find(event_name_params[:id])
      event.name = event_name_params[:eventName]
      render json: { status: 'ERROR', data: event.errors } unless event.save

      items = items_params
      items.each do |item|
        next if item[:name] == '' || item[:need_number] == ''

        if event.items.find_by(name: item[:name])
          # 数だけ変えるとき

          new_item = event.items.find_by(name: item[:name])
          unless new_item.update(need_number: item[:need_number])
            render json: { status: 'ERROR',
                           data: new_item.errors }
          end
        else
          new_item = Item.new(name: item[:name], need_number: item[:need_number])
          new_item.event_id = event.id
          render json: { status: 'ERROR', data: new_item.errors } unless new_item.save
        end
      end
      head :ok
    end

    private

    def item_params
      params.require(:item).permit(:event_id, need_number: [], name: [])
    end

    def items_params
      params.require(:items)
    end

    def event_params
      params.require(:event).permit(:name)
    end

    def event_name_params
      params.permit(:eventName, :id)
    end
  end
end
