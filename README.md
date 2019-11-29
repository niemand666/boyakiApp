# README

## サイト
ご覧になる際はURLにアクセスのうえ、下記アカウントでログインください。  
・URL: http://52.192.191.134/  
・メールアドレス: test@gmail.com  
・パスワード: 123456  

<img width="300" alt="6bd7cf48da7b48a7e36ba6905eb16f76" src="https://user-images.githubusercontent.com/54017804/69845778-23f71f80-12b5-11ea-91d7-2c14531d0e1f.png">  



## 概要
ユーザーが抱えている悩みを素直に書き出して整理することでストレスの軽減が可能になり、更に第三者のユーザーからの客観的な意見をもらえる場としてのアプリケーションを目指しています。

## 制作背景
私自身が過去に悩みを抱えて苦しんでいた時期に、ノートに悩みを箇条書きで書き出してみたら気分が落ち着いた、という経験があったため、今回のアプリケーションを制作しました。

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

### Association
- belongs_to :user
- has_many :comments
- has_many :likes
- has_many :liked_users, through: :likes, source: :user


## likes table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|post_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post


## comments table
|Column|Type|Options|
|------|----|-------|
|text|string|null: false|
|user_id|integer|null: false|
|post_id|integer|null: false|

### Association
- belongs_to :user
- belongs_to :post
