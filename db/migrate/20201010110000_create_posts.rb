class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :ip
      t.string :content
      t.references :user, foreign_key: true, null: false
    end
  end
end