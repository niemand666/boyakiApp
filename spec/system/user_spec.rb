require 'rails_helper'

RSpec.describe 'ログイン機能のシステムテスト', type: :system, js: true do
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

  describe 'log_in' do
    context 'ユーザー新規登録完了済みの場合' do
      before do
        user = create(:user, email: 'dog@gmail.com')
        visit new_user_session_path
      end

      it '正しいメールアドレスとパスワードを入力すれば、ログインできる' do
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '00000000'
        find('input[name="commit"]').click
        expect(page).to have_content('新規投稿')
      end

      it '間違ったメールアドレスを入力すると、ログインできない' do
        fill_in 'user[email]', with: 'cat@gmail.com'
        fill_in 'user[password]', with: '00000000'
        find('input[name="commit"]').click
        expect(page).to have_no_content('新規投稿')
      end

      it '間違ったパスワードを入力すると、ログインできない' do
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '00001111'
        find('input[name="commit"]').click
        expect(page).to have_no_content('新規投稿')
      end
    end

    context 'ユーザー新規登録が未完了の場合' do
      before do
        visit new_user_session_path
      end
      it 'DBに存在しないメールアドレスとパスワードを入力しても無効' do
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '00000000'
        find('input[name="commit"]').click
        expect(page).to have_no_content('新規投稿')
      end
    end
  end

  describe 'log_out' do
    context 'ユーザーがログインしている場合' do
      before do
        user = create(:user, email: 'dog@gmail.com')
        visit new_user_session_path
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '00000000'
        find('input[name="commit"]').click
      end

      it 'ログアウトが可能' do
        visit root_path
        click_link 'ログアウト'
        expect(page).to have_content('ログイン')
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ログインボタンが表示されない' do
        visit root_path
        expect(page).to have_no_content('ログアウト')
      end
    end
  end
end
