# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event) { create(:event) }
  let(:user) { create(:user) }

  describe 'イベントShowページのテスト' do
    it 'レスポンスのステータスが「200（成功）」であることを確認' do
      cookies.signed[:user_id] = user.id
      get :show, params: { id: event.id }
      expect(response).to be_successful
    end

    it 'セッションがnullの場合ユーザーの新規作成画面にに遷移することを確認する' do
      cookies.signed[:user_id] = nil
      get :show, params: { id: event.id }
      expect(response).to redirect_to new_user_path
    end
  end
end
