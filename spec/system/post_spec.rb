require 'rails_helper'

RSpec.describe '記事投稿機能のシステムテスト', type: :system, js: true do
  describe '投稿機能' do
    file_path = "#{Rails.root}/spec/fixtures/image.jpg"

    before do
      user = create(:user, email: 'dog@gmail.com')
    end

    context 'ログインしていない場合' do
      it '新規投稿ボタンが表示されない' do
        visit root_path
        expect(page).to have_no_content '新規投稿'
      end
    end

    context 'ログインした場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: 'dog@gmail.com'
        fill_in 'user[password]', with: '00000000'
        find('input[name="commit"]').click
      end

      it '新規投稿ボタンが表示される' do
        expect(page).to have_content '新規投稿'
      end

      it '新規投稿画面に遷移できる' do
        click_link '新規投稿'
        expect(new_post_path).to eq '/posts/new'
      end

      context '画像1枚で投稿する場合' do
        before do
          click_link '新規投稿'
          fill_in 'post[title]', with: 'タイトル1'
          fill_in 'post[content]', with: 'こんばんは。'
          attach_file 'pictures[picture][]', file_path, visible: false
          find('input[name="commit"]').click
        end

        it '記事の投稿できる' do
          post = Post.last
          expect(post.title).to eq 'タイトル1'
        end

        it '詳細ページに遷移する' do
          post = Post.last
          expect(current_path).to eq ("/posts/#{post.id}")
        end

        it 'トップページに反映される' do
          visit root_path
          expect(page).to have_content 'タイトル1'
        end

        it '記事詳細ページに内容が反映される' do
          visit root_path
          click_link '読む'
          expect(page).to have_content 'タイトル1'
          expect(page).to have_content 'こんばんは。'
          expect(page).to have_selector ("img[src$='image.jpg']")
        end
      end

      context '画像5枚で投稿する場合' do
        before do
          click_link '新規投稿'
          fill_in 'post[title]', with: 'タイトル2'
          fill_in 'post[content]', with: 'おはようございます。'
          attach_file 'pictures[picture][]', file_path, visible: false
          attach_file 'pictures[picture][]', file_path, match: :first, visible: false
          attach_file 'pictures[picture][]', file_path, match: :first, visible: false
          attach_file 'pictures[picture][]', file_path, match: :first, visible: false
          attach_file 'pictures[picture][]', file_path, match: :first, visible: false
          find('input[name="commit"]').click
        end

        it '記事の投稿できる' do
          post = Post.last
          expect(post.title).to eq 'タイトル2'
        end

        it '記事詳細ページに内容が反映される' do
          visit root_path
          click_link '読む'
          expect(page).to have_content 'タイトル2'
          expect(page).to have_content 'おはようございます。'
          expect(page).to have_selector("img[src$='image.jpg']", count: 5)
        end
      end
    end
  end
end
