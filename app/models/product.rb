class Product < ApplicationRecord
  include AmazonApi
  include ActiveModel::Dirty 

  belongs_to :group
  has_one :daily_change, dependent: :destroy

  validate :check_asin, :check_limit, :on => :create
  after_update :record_if_changed

  def refresh_data
    item = AmazonApi.by_asin(self.amazon_asin, "ItemAttributes,Reviews,SalesRank")
    self.extract_data(item)
    images_xml = AmazonApi.by_asin(self.amazon_asin, "Images")
    self.image_data = images_xml
    self.save
  end

  def self.new_from_asin(asin, group_id)
    item = AmazonApi.by_asin(asin, "ItemAttributes,Reviews,SalesRank")
    product = new_from_hash(item, group_id)
    images_xml = AmazonApi.by_asin(asin, "Images")
    product.image_data = images_xml
    product
  end

  def self.new_from_url(url, group_id)
    path = URI.parse(url).path.downcase
    if path.include? '/dp/'
      asin = path.split('/dp/')[1].split('/')[0] 
    elsif path.include? '/gp/product/'
      asin = path.split('/gp/product/')[1].split('/')[0]
    else
      asin = nil
    end
    if asin.nil?
      self.new(group_id: group_id) # nb since asin is nil, will raise validation error when saving
    else
      new_from_asin(asin, group_id)
    end
  end
  
  def self.new_from_hash(item, group_id)
    new = Product.new(group_id: group_id)
    new.extract_data(item)
    new
  end

  def extract_data(item)
    self.title = item["ItemAttributes"]["Title"]
    # new.price = item["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
    self.price = item["ItemAttributes"]["ListPrice"]["Amount"]
    self.currency_code = item["ItemAttributes"]["ListPrice"]["CurrencyCode"]
    self.amazon_url = item["DetailPageURL"]
    self.amazon_asin = item["ASIN"]
    self.reviews_url = item["CustomerReviews"]["IFrameURL"]
    # self.best_seller_rank = item["SalesRank"]
    self.best_seller_rank = self.scrape_best_seller_rank
    self.inventory = item["ItemAttributes"]["TotalNew"]
    self.features = item["ItemAttributes"]["Feature"]
    self.number_of_reviews = self.scrape_review_count
  end

  def scrape_review_count
    page = AmazonApi.get_html(self.reviews_url)
    parse_page = Nokogiri::HTML(page)
    text = parse_page.css('.crAvgStars').children.children.text.strip
    number = text.strip.split(' ')[0]
    count = number.last(number.length-1)
  end

  def scrape_best_seller_rank
    # page = AmazonApi.get_html(self.amazon_url)
    # parse_page = Nokogiri::HTML(page)
    # text = parse_page.css('#SalesRank').children.children.text.strip    
    10 #TODO: scrape actual number
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
    existing = DailyChange.find_by(product_id: self.id)
    existing.delete unless existing.nil?
    daily = DailyChange.new
    daily.changes_made = self.saved_changes
    self.daily_change = daily
    daily.save
  end

  def check_asin
    self.errors.add(:amazon_url, "is invalid, does not contain ASIN") if self.amazon_asin.nil?
  end
end
