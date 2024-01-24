class CreateCommentRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.integer :rating, null: false, default: 0 # 0 for neutral, 1 for like, -1 for dislike

      t.timestamps
    end
  end
end
