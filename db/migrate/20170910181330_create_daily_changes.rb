class CreateDailyChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_changes do |t|
      t.references :product, foreign_key: true
      # t.integer :product_id, :options => 'PRIMARY KEY'
      t.json :changes_made

      t.timestamps
    end
  end
end
