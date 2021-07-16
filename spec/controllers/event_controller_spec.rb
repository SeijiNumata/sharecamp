# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before do
    @event = create(:event)
    @user = create(:user)
  end

  describe 'ユーザーのcookieがプラウザに登録されている場合' do
    it 'レスポンスのステータスが「200（成功）」であることを確認' do
      cookies.signed[:user_id] = @user.id
      get :show, params: { id: @event.id }
      expect(response).to be_successful
    end
  end

  describe 'ユーザーの新規作成画面にに遷移することを確認' do
    it 'セッショsンのtest' do
      cookies.signed[:user_id] = nil
      get :show, params: { id: @event.id }
      expect(response).to redirect_to new_user_path
    end
  end
end
