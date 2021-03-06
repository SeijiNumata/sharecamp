# frozen_string_literal: true

class UserBringItem < ApplicationRecord
  belongs_to :item
  belongs_to :user
  validates :item, presence: true
  validates :user, presence: true
end
