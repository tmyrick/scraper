class Product < ApplicationRecord

  validate :asin_or_url

  private

  def asin_or_url
    unless amazon_asin.blank? ^ amazon_url.blank?
      errors.add(:base, "Specify the URL or ASIN, not both")
    end
  end
end
