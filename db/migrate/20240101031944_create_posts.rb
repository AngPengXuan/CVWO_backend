class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :category, null:false
      t.bigint :like_count, null:false, default: 0
      t.bigint :dislike_count, null:false, default: 0

      t.timestamps
    end
  end
end
