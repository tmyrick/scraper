class DailyChange < ApplicationRecord
  belongs_to :product
  default_scope { order("product_id ASC") }
end
