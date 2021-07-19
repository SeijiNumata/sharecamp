# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do
  let(:event) { create(:event) }
  let(:user) { create(:user) }

  describe 'api/eventsのテスト' do
    it 'createにリクエストを送ると、レスポンスのステータスが「200（成功）」であること' do
      name = []
      need_number = []
      event.items.each do |item|
        name.push(item.name)
        need_number.push(item.need_number)
        expect(response).to be_successful
      end

      post :create, params: { event: { name: event.name }, item: { name: name, need_number: need_number } }
    end

    it 'updateにリクエストを送ると、レスポンスのステータスが「200（成功）」であること' do
      items = [{ name: 'test_name', need_number: 3, readonly: true }]

      put :update, params: { id: event.id, eventName: event.name, items: items }
      expect(response).to be_successful
    end
  end
end
