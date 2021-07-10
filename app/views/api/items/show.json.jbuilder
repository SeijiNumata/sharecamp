# frozen_string_literal: true

json.item @item
json.user_bring_items @item.user_bring_items
json.bring_item_names do
  json.array!(@item.user_bring_items) do |user_bring_item|
    json.partial!(user_bring_item)
  end
end
