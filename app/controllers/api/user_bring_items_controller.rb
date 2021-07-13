# frozen_string_literal: true

module Api
  class UserBringItemsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      user_bring_item = UserBringItem.new(user_bring_item_bring_number_params)
      item = Item.find(item_params[:id])

      item.user_bring_items << user_bring_item
      current_user.user_bring_items << user_bring_item
      if user_bring_item.save
        head :ok
      else
        head :bad_request
      end
    end

    def destroy
      set_user_bring_item
      if @user_bring_item.destroy!
        head :ok
      else
        head :bad_request
      end
    end

    def update
      set_user_bring_item

      if @user_bring_item.update(user_bring_item_params)
        head :ok
      else
        head :bad_request
      end
    end

    private

    def item_params
      params.require(:item).permit(:id)
    end

    def user_bring_item_bring_number_params
      params.permit(:bring_number)
    end

    def user_bring_item_params
      params.require(:user_bring_item).permit(:check, :id)
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def set_user_bring_item
      @user_bring_item = UserBringItem.find(params[:id])
    end
  end
end
