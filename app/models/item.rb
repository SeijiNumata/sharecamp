# frozen_string_literal: true

class Item < ApplicationRecord
   belongs_to :event
   has_many :user_bring_items,dependent: :destroy
   has_many :users, through: :user_bring_items
end
