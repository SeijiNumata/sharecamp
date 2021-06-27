# frozen_string_literal: true

json.set! :items do
  json.array! @items do |item|
    json.extract! item, :id, :name, :events_id, :need_number, :created_at, :updated_at
  end
end
