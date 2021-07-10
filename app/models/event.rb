# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :users_events, dependent: :destroy
  has_many :users, through: :users_events
  accepts_nested_attributes_for :users_events

  before_create :generate_token

  def generate_token
    self.id = loop do
      random_token = SecureRandom.uuid
      break random_token unless self.class.exists?(id: random_token)
    end
  end
end
