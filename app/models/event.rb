# frozen_string_literal: true

class Event < ApplicationRecord
   has_many :items
   has_many :users

   before_create :generate_token

  def generate_token
    self.id = loop do
      random_token = SecureRandom.uuid
      break random_token unless self.class.exists?(id: random_token)
    end
  end
end
