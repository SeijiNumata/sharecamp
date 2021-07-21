# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.describe 'ユーザーの切り替え', type: :feature, js: true do
  let(:event) { create(:event) }

  before do
    event
    visit "events/#{event.id}"
    fill_in('user_name', with: 'たろう')
    click_on '持ってきて欲しいものリストへ'
  end

  context 'ユーザー新規作成' do
    it 'ユーザーを切り替えることができる' do
      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: 'アリス')
      click_on '持ってきて欲しいものリストへ'
      expect(page).to have_content 'アリス'
    end

    it 'ユーザーを切り替えても持ち物を記録している' do
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

  context 'ユーザー新規登録画面ののバリデーションテスト' do
    it 'ニックネームが空白だとエラーメッセージが表示される' do
      click_on 'こちら'
      fill_in('user_name', with: '')
      click_on '持ってきて欲しいものリストへ'
      expect(page).to have_content 'ニックネームは１文字以上入力してください。'
    end

    it 'ニックネームに空白スペースが含まれていた場合trimする' do
      click_on 'こちら'
      fill_in('user_name', with: '')
      fill_in('user_name', with: "空白がある\s名前")
      click_on '持ってきて欲しいものリストへ'
      expect(page).to have_content '空白がある名前'
    end
  end
end
