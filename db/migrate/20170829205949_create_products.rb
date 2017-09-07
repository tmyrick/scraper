class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :amazon_asin
      t.string :amazon_url
      t.string :reviews_url
      t.string :price
      t.string :currency_code      
      t.string :title
      t.integer :number_of_reviews
      t.integer :best_seller_rank
      t.integer :inventory
      t.text :features, array: true, default: []      
      t.text :image_data
      
      t.timestamps
    end
  end
end
