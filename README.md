# README

## サイト
ご覧になる際はURLにアクセスのうえ、下記アカウントでログインください。  
・URL: http://52.192.191.134/  
・メールアドレス: test@gmail.com  
・パスワード: 123456 

|投稿一覧ページ|投稿詳細ページ|
|---|---|
|<img width="450" height="400" alt="7050a700651fa9657b9ebcecee95674c" src="https://user-images.githubusercontent.com/54017804/69846710-3e7ec800-12b8-11ea-9171-ee554f7e928f.png">|<img width="450" height="400" alt="6bd7cf48da7b48a7e36ba6905eb16f76" src="https://user-images.githubusercontent.com/54017804/69845778-23f71f80-12b5-11ea-91d7-2c14531d0e1f.png">|

|コメント部分|
|---|
|<img width="400" height="400" alt="421bf73df042574c42b3eb06b7819c48" src="https://user-images.githubusercontent.com/54017804/69847434-77b83780-12ba-11ea-83a0-f3782024f8da.png">|

## 概要
ユーザーが抱えている悩みを素直に書き出して整理することでストレスの軽減が可能になり、更に第三者のユーザーからの客観的な意見をもらえる場としてのアプリケーションを目指しています。

## 制作背景
私自身が過去に悩みを抱えて苦しんでいた時期に、ノートに悩みを箇条書きで書き出してみたら気分が落ち着いた、という経験があったため、今回のアプリケーションを制作しました。

## 機能一覧及び使用技術
フロントエンド  
・Haml/Sassによるマークアップ  

サーバサイド  
・ユーザー登録機能(gem deviseを使用)  
・ユーザーマイページ  
・投稿一覧表示  
・記事の投稿機能  
・記事の編集機能  
・記事の削除機能  
・記事に対する「いいね」ボタン  
・「いいね」カウント機能  
・記事に対するコメント機能  
・検索機能(gem ransackを使用)  
・ページネーション(gem kaminariを使用)  
・単体テスト(RSpec)  
・統合テスト(RSpec)  

インフラ  
・Docker、docker-composeによる開発環境、テスト環境構築  
・仮想サーバーEC2(AWS)を使用  
・AWS S3への画像アップロード(gem CarrierWaveを使用)  
・Capistranoを用いた自動デプロイ  

## 追加予定機能
・コメントの非同期通信化  
・フォロワー機能  
・単体テスト 随時進めていきます  
・統合テスト 随時進めていきます  
・CircleCIによる自動テスト  
・CircleCIによる自動デプロイ  

## 工夫した点
・js.erbを使っていいねボタンを非同期化しました。ボタンを押すと色が代わり、いいね数が変化します。  
・サイト全体をシンプルなデザインにして見やすさを重視しました。  

# データベース設計

## users table
|Column|Type|Options|
|------|----|-------|
|email|string|null: false|
|password|string|null: false|
|nickname|string|null: false|
|image|string|null: false|

### Association
- has_many :posts, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many :likes, dependent: :destroy
- has_many :liked_posts, through: :likes, source: :post


## posts table
|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|content|text|null: false|
|user_id|bigint|null: false, foreign_key: true|

### Association
- belongs_to :user
- has_many :comments
- has_many :likes
- has_many :liked_users, through: :likes, source: :user


## likes table
|Column|Type|Options|
|------|----|-------|
|user_id|bigint|null: false, foreign_key: true|
|post_id|bigint|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post


## comments table
|Column|Type|Options|
|------|----|-------|
|text|text|null: false|
|user_id|bigint|null: false, foreign_key: true|
|post_id|bigint|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post
