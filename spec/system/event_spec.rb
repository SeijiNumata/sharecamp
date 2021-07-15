# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.feature '画面遷移', type: :feature, js: true do
  scenario '新規作成時にユーザー作成ページに遷移してから詳細ページに遷移すること' do
    visit '/events/new'
 
    expect(page).to have_content '新規作成'
    fill_in('○○大学卒業キャンプ', with: 'タイトル')
    fill_in('テント', with: 'テント')
    first('.item-number').find(:xpath, 'option[4]').select_option
    click_on "この内容で登録"
    expect(page).to have_content "タイトルの\n誰か持ってきてリストへようこそ"
  end
end
