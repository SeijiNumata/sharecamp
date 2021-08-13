# frozen_string_literal: true

require 'rails_helper'
#   save_and_open_screenshot

RSpec.describe '持っていく物リストのシステムテスト', type: :feature, js: true do
  let(:event) { create(:event) }

  before do
    event
    visit "events/#{event.id}"
    fill_in('user_name', with: 'たろう')
    click_on '持ってきて欲しい物リストへ'
  end

  context '新規画面のバリデーションテスト' do
    it '持ち物リストの名前が空白の時に、イベントが作成できないこと' do
      page.all('.number-select')[0].find(:xpath, 'option[5]').select_option
      page.all('.bring-button')[0].click

      find('.current-user-bring-item-tab').click

      expect(page).to have_content "#{event.items[0].name}(4)"
      expect(page.all('#checkbox')[0].checked?).to be false
    end
  end
end
