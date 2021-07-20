# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  let(:event) { create(:event) }

  describe 'api/itemsのテスト' do
    it 'deleteにリクエストを送ると、レスポンスのステータスが「200（成功）」であること' do
      delete :destroy, params: { id: event.items[0].id }
      expect(response).to be_successful
    end
  end
end
