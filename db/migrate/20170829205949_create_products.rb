class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.decimal :price
      t.string :title
      t.integer :number_of_reviews
      t.integer :best_seller_rank
      t.integer :inventory

      t.timestamps
    end
  end
end
