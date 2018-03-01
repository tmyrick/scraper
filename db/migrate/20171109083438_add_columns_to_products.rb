class AddColumnsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :brand, :string
    add_column :products, :binding, :string
    add_column :products, :color, :string
    add_column :products, :manufacturer, :string
    add_column :products, :model, :string
    add_column :products, :upc, :string
    add_column :products, :lowest_new_price, :float
    add_column :products, :release_date, :datetime
    add_column :products, :lowest_used_price, :float
    add_column :products, :total_offers, :integer
    add_column :products, :more_offers_url, :string
    add_column :products, :merchant, :string
    add_column :products, :availability, :integer
    add_column :products, :super_saver_eligibility, :boolean
    add_column :products, :prime_eligibility, :boolean
    add_column :products, :similar_products, :text
  end
end
