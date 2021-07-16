# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.feature 'ユーザーの切り替え', type: :feature, js: true do
  context 'ユーザー新規作成' do
    let(:event) { create(:event) }
    before do
      event
      visit "events/#{event.id}"
      fill_in('user_name', with: 'たろう')
      click_on '持ってきて欲しいものリストへ'
    end
    scenario 'ユーザーを切り替えることができる' do
      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'アリス')
      click_on '持ってきて欲しいものリストへ'
      expect(page).to have_content 'アリス'
    end

    scenario 'ユーザーを切り替えても持ち物を記録している' do
      first('.number-select').find(:xpath, 'option[4]').select_option
      first('.bring-button').click

      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'アリス')
      click_on '持ってきて欲しいものリストへ'
      expect(page).to have_content 'アリス'

      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'たろう')
      click_on '持ってきて欲しいものリストへ'
      expect(page).to have_content 'たろう(3)'
    end
  end
end
