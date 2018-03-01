class AddEditorialReviewsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :editorial_review, :text
  end
end
