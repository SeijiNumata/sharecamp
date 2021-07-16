# frozen_string_literal: true

class User < ApplicationRecord
  has_many :users_events, dependent: :destroy
  has_many :events, through: :users_events
  has_many :user_bring_items, dependent: :destroy
  has_many :items, through: :user_bring_items

  validates :name,presence:  { message: 'は１文字以上入力してください。' }
end
