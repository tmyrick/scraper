class Product < ApplicationRecord
  include AmazonAPI

  belongs_to :group
  validate :check_limit, :on => :create
  
  def self.new_from_asin(asin)
    item = AmazonAPI.by_asin(asin, "ItemAttributes,Reviews,SalesRank")
    product = new_from_hash(item)
    images_xml = AmazonAPI.by_asin(asin, "Images")
    product.image_data = images_xml
    product
  end

  def self.new_from_url(url)
    item = AmazonAPI.by_url(url)
    new_from_hash(item)
  end
  
  def self.new_from_hash(item)
    new = Product.new
    new.title = item["ItemAttributes"]["Title"]
    # new.price = item["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
    new.price = item["ItemAttributes"]["ListPrice"]["Amount"]
    new.currency_code = item["ItemAttributes"]["ListPrice"]["CurrencyCode"]
    new.amazon_url = item["DetailPageURL"]
    new.amazon_asin = item["ASIN"]
    new.reviews_url = item["CustomerReviews"]["IFrameURL"]
    new.best_seller_rank = item["SalesRank"]
    new.inventory = item["ItemAttributes"]["TotalNew"]
    new.features = item["ItemAttributes"]["Feature"]
    # new.number_of_reviews
    # new.image =     
    new
  end

  def check_limit
    if self.group.products(:reload).count >= 8
      errors.add(:base, "Exceeded Product limit (only 8 products allowed in a group)")
    end
  end
  
end
