# app/models/user.rb
class User < ApplicationRecord
  has_many :posts
  has_many :post_ratings
  has_secure_password
end
