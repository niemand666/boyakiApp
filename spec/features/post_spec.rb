require 'rails_helper'

feature 'post', type: :feature do
# このブロックの内部にscenarioを記述していく
  let(:user) { create(:user) }

  scenario 'post post' do
    # ログイン前には投稿ボタンがない
    visit root_path
    expect(page).to have_no_content('投稿する')
    # ログイン処理
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    expect(page).to have_content('投稿する')
    # 記事の投稿
    expect {
      click_link('投稿する')
      expect(current_path).to eq new_post_path
      fill_in 'post[title]', with: 'フィーチャスペックのテスト'
      fill_in 'post[content]', with: 'フィーチャスペックのテスト'
      find('input[type="submit"]').click
    }.to change(Post, :count).by(1)
  end

end
