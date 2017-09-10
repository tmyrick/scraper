class Group < ApplicationRecord
  has_many :products

  validate :check_limit, :on => :create

  def check_limit
    if Group.count >= 10
      errors.add(:base, "Exceeded Group limit (only 10 groups allowed)")
    end
  end
end
