json.extract! product, :id, :price, :title, :number_of_reviews, :best_seller_rank, :inventory, :created_at, :updated_at
json.url product_url(product, format: :json)
