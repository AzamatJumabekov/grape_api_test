class User < ActiveRecord::Base
  has_many :posts

  validates :login, presence: true
end
