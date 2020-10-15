class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :value, limit: 1, null: false
      t.references :post, foreign_key: true, null: false
    end
  end
end
