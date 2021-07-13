require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new task" do
    # ユーザーを作成
    expect(1 + 1).to eq 2
  end
end
