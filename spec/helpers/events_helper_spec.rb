# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  it 'おらら' do
    @event = create(:event)
    @user = create(:user)
    helper.current_user_test(@user.id)
    expect(helper.current_user_test('a')).to eq('a')
  end
end
