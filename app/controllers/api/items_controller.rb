# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      item_params_id
      set_item
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

    def set_item
      @item = Item.find(params[:id])
    end
  end
end
