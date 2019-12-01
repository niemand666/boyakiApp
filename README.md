## 自作アプリ「まいったね」
ご覧になる際はURLにアクセスのうえ、下記アカウントでログインください。  
・URL: http://52.192.191.134/  
・メールアドレス: test@gmail.com  
・パスワード: 123456 

|記事詳細ページ|ユーザーマイページ|
|---|---|
|<img width="450" height="400" alt="b0d97412a76a0496490ab48ce77d4062" src="https://user-images.githubusercontent.com/54017804/69917715-57e86580-14ac-11ea-848c-927efdffaa7d.png">|<img width="450" height="400" alt="74ab39a34a15301ae0f649c4155b737b" src="https://user-images.githubusercontent.com/54017804/69917730-836b5000-14ac-11ea-81cc-eaec746934b7.png">|

|通知画面|フォロワー画面|
|---|---|
|<img width="450" height="400" alt="ac8a32cd2c0aa8c9faa25f9da6d160a1" src="https://user-images.githubusercontent.com/54017804/69917777-1efcc080-14ad-11ea-8f36-b5f145abde3c.png">|<img width="450" height="400" alt="b21fb9c2bb74d8bd57e6b139fc15d94b" src="https://user-images.githubusercontent.com/54017804/69917791-418ed980-14ad-11ea-8c3a-b49fe12b81c4.png">|


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
・フォロワー機能  
・記事の投稿  
・記事の編集  
・記事の削除  
・いいねボタン(非同期)  
・コメント機能  
・コメント機能の非同期通信  
・新規フォローワー、新規コメント、新規いいねの通知機能  
・記事検索機能(gem ransackを使用)  
・ページネーション(gem kaminariを使用)  
・単体テスト(RSpec)  
・統合テスト(RSpec)  

インフラ  
・Docker、docker-composeによる開発環境、テスト環境構築  
・仮想サーバーEC2(AWS)を使用  
・AWS S3への画像アップロード(gem CarrierWaveを使用)  
・Capistranoを用いた自動デプロイ  


## 追加予定機能
・単体テスト 随時進めていきます  
・統合テスト 随時進めていきます  
・CircleCIによる自動テスト  
・CircleCIによる自動デプロイ  


## 工夫した点
・自分以外のユーザーが自分の投稿にいいねやコメントをすると、マイページ内のボタンを変化させてユーザーに知らせます。
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
- has_many :relationships
- has_many :followings, through: :relationships, source: :follow
- has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
- has_many :followers, through: :reverse_of_relationships, source: :user
- has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
- has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy


## relationships table
|Column|Type|Options|
|------|----|-------|
|user_id|bigint|foreign_key: true|
|follow_id|bigint|foreign_key: true|

### Association
- belongs_to :user
- belongs_to :follow, class_name: 'User'


## posts table
|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|content|text|null: false|
|user_id|bigint|foreign_key: true|

### Association
- belongs_to :user
- has_many :comments
- has_many :likes
- has_many :liked_users, through: :likes, source: :user
- has_many :notifications, dependent: :destroy


## likes table
|Column|Type|Options|
|------|----|-------|
|user_id|bigint|foreign_key: true|
|post_id|bigint|foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post


## comments table
|Column|Type|Options|
|------|----|-------|
|text|text|null: false|
|user_id|bigint|foreign_key: true|
|post_id|bigint|foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post

## notifications table
|Column|Type|Options|
|------|----|-------|
|visitor_id|integer|null: false|
|visited_id|integer|null: false|
|post_id|integer|---|
|comment_id|integer|---|
|action|string|default: '', null: false|
|checked|boolean|default: false, null: false|

### Association
- belongs_to :post, optional: true
- belongs_to :comment, optional: true
- belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
- belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true