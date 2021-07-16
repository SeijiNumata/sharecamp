# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @event = create(:event)
    @user = create(:user)
  end

  describe 'events/users/newのテスト' do
    it 'session[:event_id] がない場合はtopページにリダイレクトする' do
      get :new
      expect(response).to redirect_to root_path
    end

    it 'session[:event_id] がある場合はsuccessが返ってくる' do
      session[:event_id] = @event.id
      get :new
      expect(response).to be_successful
    end
  end
end
