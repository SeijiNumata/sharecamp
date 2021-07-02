class User < ApplicationRecord
    has_many :users_events
    has_many :events, through: :users_events
    accepts_nested_attributes_for :users_events
    has_many :user_bring_items
    has_many :items, through: :user_bring_items

    
end
