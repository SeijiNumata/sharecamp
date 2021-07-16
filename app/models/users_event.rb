# frozen_string_literal: true

class UsersEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true
end
