# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.feature '画面遷移', type: :feature, js: true do
  scenario '新規作成時のページ遷移' do
    visit '/events/new'
 
    expect(page).to have_content '新規作成'
    fill_in('○○大学卒業キャンプ', with: 'タイトル')
    fill_in('テント', with: 'テント')
    select '数', from: 'japanese_calendar'
    save_and_open_screenshot
    
    expect(page).to have_content '新規作成  and'
  end
end
