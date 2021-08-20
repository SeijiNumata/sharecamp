# frozen_string_literal: true

require 'rails_helper'
# 'save_and_open_screenshot'can debug and take screenshot

RSpec.describe 'イベントのシステムテスト', type: :feature, js: true do
  let(:event) { create(:event) }

  context '新規作成画面のテスト' do
    it '新規作成時、event/users/newに遷移してからevent/idに遷移すること' do
      visit '/events/new'
      expect(page).to have_content '持ち物分担リスト作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')
      fill_in('テント', with: 'テント')
      first('.item-number').find(:xpath, 'option[4]').select_option

      click_on 'この内容で登録'
      expect(page).to have_content "タイトルの\n持ち物分担リストへようこそ"
      expect(page).to have_current_path new_user_path, ignore_query: true

      fill_in('user_name', with: 'たろう')

      click_on '持ち物分担リストへ'

      click_on '閉じる'
      expect(page).to have_content 'テント'
      expect(page).to have_content 'タイトル'
    end
  end

  context '新規画面のバリデーションテスト' do
    it '持ち物分担リストの名前が空白の時に、イベントが作成できないこと' do
      visit '/events/new'
      expect(page).to have_content '持ち物分担リスト作成'
      fill_in('テント', with: 'テント')
      first('.item-number').find(:xpath, 'option[4]').select_option

      click_on 'この内容で登録'
      expect(page).to have_content '※イベント名を入力してください'
    end

    it '持っていく物が最低１つ以上登録されていないと、イベント作成ができないこと' do
      visit '/events/new'
      expect(page).to have_content '持ち物分担リスト作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')

      click_on 'この内容で登録'
      expect(page).to have_content '※持ち物を入力してください'
    end

    it '持っていく物の数が入力されていないとき、イベント作成ができないこと' do
      visit '/events/new'
      expect(page).to have_content '持ち物分担リスト作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')
      fill_in('テント', with: 'テント')

      click_on 'この内容で登録'
      expect(page).to have_content '※持ち物の数を入力してください'
    end

    it '持っていく物の数だけ登録されていて名前が入力されていない時、イベント作成ができないこと' do
      visit '/events/new'
      expect(page).to have_content '持ち物分担リストト作成'
      fill_in('○○大学卒業キャンプ', with: 'タイトル')
      first('.item-number').find(:xpath, 'option[4]').select_option

      click_on 'この内容で登録'
      expect(page).to have_content '※持ち物を入力してください'
    end
  end

  context '編集画面のテスト' do
    before do
      event
      visit "events/#{event.id}"
      fill_in('user_name', with: 'たろう')
      click_on '持ち物分担リストへ'
      click_on '内容変更'
    end

    it '既存の持ち物の数を編集できること' do
      first('.item-number').find(:xpath, 'option[4]').select_option
      click_on 'この内容で登録'

      expect(page).to have_content "持ってきて\nほしい物"

      expect(page).to have_content "#{event.items[0].name} (0/6)"
    end

    it '既存の持ち物の名前を編集できないようになっていること' do
      expect(page.all('.item-name')[0].readonly?).to be true
    end

    it '既存のイベントの名前を変更できること' do
      find('.event-name').set('')
      find('.event-name').set('変更したイベントタイトル')
      click_on 'この内容で登録'
      expect(page).to have_content "持ってきて\nほしい物"
      expect(page).to have_content '変更したイベントタイトル'
    end

    it '新たな持ち物と数を追加して登録することができること' do
      click_on('追加する')
      page.all('.item-name')[3].fill_in(with: '新しい持ち物')
      page.all('.item-number')[3].find(:xpath, 'option[3]').select_option
      click_on 'この内容で登録'
      expect(page).to have_content '新しい持ち物 (0/2)'
    end

    it '持ち物を削除することができる' do
      first('.delete-button').click
      page.driver.browser.switch_to.alert.accept
      click_on 'この内容で登録'
      expect(page).not_to have_content 'TEST_ITEM_NAME1'
    end
  end

  context 'indexページのテスト' do
    it '直近に見た詳細ページ５つまで、/eventsのindexから名前だけ見ることができる。' do
      events = []
      6.times { |n| events[n] = create(:event) }

      visit "events/#{events[0].id}"
      fill_in('user_name', with: 'たろう')

      click_on '持ち物分担リストへ'

      5.times { |n| visit "events/#{events[n].id}" }

      visit '/events'

      5.times { |n| expect(page).to have_content events[n].name }
    end
  end
end
