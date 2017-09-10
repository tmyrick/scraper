class Product < ApplicationRecord
  include AmazonAPI
  include ActiveModel::Dirty 

  belongs_to :group
  has_one :daily_change

  validate :check_limit, :on => :create
  after_update :record_if_changed

  def self.new_from_asin(asin, group_id)
    item = AmazonAPI.by_asin(asin, "ItemAttributes,Reviews,SalesRank")
    product = new_from_hash(item, group_id)
    images_xml = AmazonAPI.by_asin(asin, "Images")
    product.image_data = images_xml
    product
  end

  def self.new_from_url(url)
    item = AmazonAPI.by_url(url)
    new_from_hash(item)
  end
  
  def self.new_from_hash(item, group_id)
    new = Product.new(group_id: group_id)
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

  private

  def check_limit
    if self.group.products.count >= 8
      errors.add(:base, "Exceeded Product limit (only 8 products allowed in a group)")
    end
  end

  def record_if_changed
    puts self.saved_changes
    record_changes if self.saved_changes.length > 0
  end

  def record_changes
    daily = DailyChange.new
    daily.changes_made = self.saved_changes
    self.daily_change = daily
    daily.save
  end

end
