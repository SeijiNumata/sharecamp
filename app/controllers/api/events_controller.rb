# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token
    protect_from_forgery
    #   def index
    #     @items = Item.order('created_at DESC')
    #   end

    
    #   def show
    #     set_item
    #     respond_to do |format|
    #       format.json
    #     end
    #     #render json: @item
    #   end

    # #   def new
    # #     @event = Event.new
    # #   end

    def create
      @event = Event.new(event_params)
      if @event.save
        item_params[:name].count.times do |i|
          @item = Item.new
          @item.name = item_params[:name][i]
          @item.need_number = item_params[:need_number][i]
          @item.event_id = @event.id
          render json: { status: 'ERROR', data: @item.errors } unless @item.save
        end
      else
        # render json: { status: 'ERROR', data: @event.errors }
        # returnF
      end
      session[:fromCreate] = 'fromCreate'
      session[:event_id] = @event.id
      render json: @event, status: :created
    end
    # #   def create
    # #     @event = Event.new(event_params)
    # #     if @event.save
    # #       item_params[:name].count.times do |i|
    # #         @item = Item.new
    # #         @item.name = item_params[:name][i]
    # #         @item.need_number = item_params[:need_number][i]
    # #         @item.event_id=@event.id
    # #         unless @item.save
    # #           render json: { status: 'ERROR', data: @item.errors }
    # #         end
    # #       end
    # #     else
    # #       # render json: { status: 'ERROR', data: @event.errors }
    # #       # returnF
    # #     end
    # #     render json: @event, status: :created
    # #     # render json: { status: 'ERROR', data: @item.errors }
    # #     # # format.html { redirect_to @event, notice: 'Event was successfully created.' }
    # #     # # format.json { render json: { status: 'SUCCESS', data: @item }}
    # #     # # #render json: @item, status: :created
    # #     # #  #render json: @item.errors, status: :unprocessable_entity
    # #     # #  render json: { status: 'ERROR', data: @item.errors
    # #     # render :show, status: :created
    # #     # redirect_to root_path
    # #     # respond_to do |format|
    # #     #     format.html { redirect_to @event, notice: 'Event was successfully created.' }
    # #     #     format.json { render :show, status: :created, location: @event }
    # #     #  end

    # #   end

    # #   def destroy
    # #     @item.destroy!
    # #   end

    def update
      items_params
      items = params[:items]
      event = Event.find(params[:id])
      event.name = params[:eventName]
      event.save!
      items.each do |item|
        next if item[:name] == '' || item[:need_number] == ''

        if event.items.find_by(name: item[:name])
          # 数だけ変える

          newItem = event.items.find_by(name: item[:name])

          newItem.update(need_number: item[:need_number])
        else
          newItem = Item.new(name: item[:name], need_number: item[:need_number])
          newItem.event_id = event.id
          newItem.save!
        end
      end
    end

    private

    #   def item_params
    #     params.require(:item).permit(:event_id, need_number: [], name: [])
    #   end

    #   def event_params
    #     params.require(:event).permit(:name)
    #   end

    #   def set_item
    #     @item = Item.find(params[:id])
    #   end

    def item_params
      params.require(:item).permit(:event_id, need_number: [], name: [])
    end

    def event_params
      params.require(:event).permit(:name)
    end

    def items_params
      params.require(:items)
      params.require(:eventName)
    end
  end
end
