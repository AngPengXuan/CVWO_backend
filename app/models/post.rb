class Post < ApplicationRecord
  has_many :post_ratings
  belongs_to :user
end
