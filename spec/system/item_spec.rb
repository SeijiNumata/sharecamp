# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.describe '持ち物のシステムテスト', type: :feature, js: true do
  let(:event) { create(:event) }

  before do
    event
    visit "events/#{event.id}"
    fill_in('user_name', with: 'たろう')
    click_on '持ち物分担リストへ'
  end

  context '詳細画面の持ち物のテスト' do
    it 'ユーザーは詳細ページがから持っていく持ち物を登録することができる' do
      expect(page.all('.bring-button')[0].disabled?).to be false
      page.all('.number-select')[0].find(:xpath, 'option[3]').select_option
      page.all('.bring-button')[0].click
      expect(page).to have_content "#{event.items[0].name} (2/6)"
      expect(page).to have_content 'たろう(2)'
      expect(page.all('.bring-button')[0].disabled?).to be true
    end

    it '詳細ページがから持っていく持ち物の数を入力しないと登録することができないこと' do
      page.all('.bring-button')[0].click
      expect(page).to have_content '※数を入力してください'
    end

    it '持っていく持ち物が登録されている上限になると持っていくボタンが押下できないこと' do
      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'アリス')
      click_on '持ち物分担リストへ'

      expect(page.all('.bring-button')[0].disabled?).to be false

      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'たろう')
      click_on '持ち物分担リストへ'
      page.all('.number-select')[0].find(:xpath, 'option[7]').select_option
      page.all('.bring-button')[0].click

      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'アリス')
      click_on '持ち物分担リストへ'
      sleep 0.2
      expect(page.all('.bring-button')[0].disabled?).to be true
    end

    it '持っていく持ち物を登録したら削除できること' do
      page.all('.number-select')[0].find(:xpath, 'option[7]').select_option
      page.all('.bring-button')[0].click

      expect(page.all('.bring-button')[0].disabled?).to be false

      click_button('×')
      expect(page.all('.bring-button')[0].disabled?).to be true
    end
  end
end
