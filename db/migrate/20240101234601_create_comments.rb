class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.text :content, null: false
      t.bigint :like_count, null: false, default: 0
      t.bigint :dislike_count, null:false, default: 0

      t.timestamps
    end
  end
end
