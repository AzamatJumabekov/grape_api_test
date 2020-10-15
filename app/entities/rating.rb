class Rating < ActiveRecord::Base
  belongs_to :post

  validates :value, presence: true
end
