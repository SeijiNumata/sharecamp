# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.feature '画面遷移', type: :feature, js: true do
  scenario '新規作成時' do
    visit '/events/new'

    expect(page).to have_content '新規作成'
    fill_in('○○大学卒業キャンプ', with: 'タイトル')
    fill_in('テント', with: 'テント')
    first('.item-number').find(:xpath, 'option[4]').select_option

    click_on 'この内容で登録'
    expect(page).to have_content "タイトルの\n誰か持ってきてリストへようこそ"
    expect(current_path).to eq new_user_path
    fill_in('user_name', with: 'たろう')

    click_on '持ってきて欲しいものリストへ'

    click_on '閉じる'
    expect(page).to have_content 'テント'
    expect(page).to have_content 'タイトル'
  end
end
