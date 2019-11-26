# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# boyakiApp database design

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
