class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :content, null: false
      t.string :average_rating
      t.string :ip, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
