require 'rails_helper'

RSpec.describe 'sign_up, sign_in, log_out', type: :system, js: true do
  describe 'sign_up' do
    before do
      visit  new_user_registration_path
    end
    context '新しいメールアドレスとパスワード打ち込んだ場合' do
      before do
        file_path = "#{Rails.root}/spec/fixtures/image.jpg"
        attach_file "user[image]", file_path
        fill_in 'user[nickname]', with: 'あいうえお'
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '1234567'
        fill_in 'user[password_confirmation]', with: '1234567'
        find('input[name="commit"]').click
        # click_button 'アカウント作成'
      end

      it '新規ユーザー登録できる' do
        expect(current_path).to eq root_path
        expect(page).to have_content('新規投稿')
      end
    end

    context '登録済みのメールアドレスを打ち込んだ場合' do
      before do
        user = create(:user, email: 'dog@gmail.com')
        file_path = "#{Rails.root}/spec/fixtures/image.jpg"
        attach_file "user[image]", file_path
        fill_in 'user[nickname]', with: 'あいうえお'
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '1234567'
        fill_in 'user[password_confirmation]', with: '1234567'
        find('input[name="commit"]').click
      end

      it '新規ユーザー登録ができない' do
        expect(page).to have_content('Email has already been taken')
      end
    end
  end
end
