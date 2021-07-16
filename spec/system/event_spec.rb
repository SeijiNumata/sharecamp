# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.feature 'イベントのシステムテスト', type: :feature, js: true do
  context '新規作成画面のテスト' do
    scenario '新規作成時、event/users/newに遷移してからevent/idに遷移すること' do
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
  context '編集画面のテスト' do
    let(:event) { create(:event) }

    before do
      event
      visit "events/#{event.id}"
      fill_in('user_name', with: 'たろう')
      click_on '持ってきて欲しいものリストへ'
      click_on '内容変更'
    end

    scenario '既存の持ち物の数を編集できること' do
      first('.item-number').find(:xpath, 'option[4]').select_option
      click_on 'この内容で登録'
      expect(page).to have_content "持ってきて\nほしいもの"
      expect(page).to have_content 'TEST_ITEM_NAME1 (0/3)'
    end

    scenario '既存のイベントの名前を変更できること' do
      find('.event-name').set('')
      find('.event-name').set('変更したイベントタイトル')
      click_on 'この内容で登録'
      expect(page).to have_content "持ってきて\nほしいもの"
      expect(page).to have_content '変更したイベントタイトル'
    end

    scenario '新たな持ち物と数を追加して登録することができること' do
      click_on('追加する')
      page.all('.item-name')[3].fill_in(with: '新しい持ち物')
      page.all('.item-number')[3].find(:xpath, 'option[3]').select_option
      click_on 'この内容で登録'
      expect(page).to have_content '新しい持ち物 (0/2)'
    end

    scenario '持ち物を削除することができる' do
      first('.delete-button').click
      page.driver.browser.switch_to.alert.accept
      click_on 'この内容で登録'
      expect(page).not_to have_content 'TEST_ITEM_NAME1'
    end
  end

  context '新規画面のバリデーションテスト' do
    scenario '持ち物リストの名前が空白の時に、イベントが作成できないこと' do
      visit '/events/new'
      expect(page).to have_content '新規作成'
      fill_in('テント', with: 'テント')
      first('.item-number').find(:xpath, 'option[4]').select_option

      click_on 'この内容で登録'
      expect(page).to have_content '※イベント名を入力してください'
    end

    scenario '持っていくものが最低１つ以上登録されていないとき、イベント作成ができないこと' do
      visit '/events/new'
      expect(page).to have_content '新規作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')
      click_on 'この内容で登録'
      expect(page).to have_content '※持ち物を入力してください'
    end


    scenario '持っていくものの数が入力されていないとき、イベント作成ができないこと' do
      visit '/events/new'
      expect(page).to have_content '新規作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')
      fill_in('テント', with: 'テント')

      click_on 'この内容で登録'
      expect(page).to have_content '※持ち物の数を入力してください'
    end

    scenario '持っていくものが最低１つ以上登録されていないとき、イベント作成ができないこと' do
      visit '/events/new'
      expect(page).to have_content '新規作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')
      # fill_in('テント', with: 'テント')
      first('.item-number').find(:xpath, 'option[4]').select_option

      click_on 'この内容で登録'
      expect(page).to have_content '※持ち物を入力してください'
    end
  end
end
