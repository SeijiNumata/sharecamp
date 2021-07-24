# frozen_string_literal: true

event = Event.create!(
  name: 'test 1月のキャンプ'
)
item1 = event.items.create!(
  name: 'まな板',
  need_number: 4
)
user1 = User.create!(name: '橋本たろう')
user2 = User.create!(name: '鈴木ゆうすけ')
user3 = User.create!(name: '高橋ゆういち')

users = [user1, user2, user3]

users.each do |user|
  user.events << event
end

item2 = event.items.create!(
  name: '食器',
  need_number: 6
)
item3 = event.items.create!(
  name: 'はし',
  need_number: 10
)

item4 = event.items.create!(
  name: 'クーラーボックス',
  need_number: 2
)

event.items.create!(
  name: 'タープ',
  need_number: 1
)

UserBringItem.create!(
  item_id: item1.id,
  user_id: user1.id,
  bring_number: 2
)

UserBringItem.create!(
  item_id: item1.id,
  user_id: user2.id,
  bring_number: 2
)
UserBringItem.create!(
  item_id: item2.id,
  user_id: user2.id,
  bring_number: 6
)
UserBringItem.create!(
  item_id: item3.id,
  user_id: user3.id,
  bring_number: 6
)
UserBringItem.create!(
  item_id: item4.id,
  user_id: user1.id,
  bring_number: 1
)

puts 'テストデータのurl'
puts "localhost:3000/events/#{event.id}"
puts ''
puts '「橋本たろう」でニックネームを入力すると、既に持ち物を登録しているユーザーでログインします。'
puts '架空のニックネームでも大丈夫です。'
