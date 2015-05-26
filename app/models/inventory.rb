class Inventory < ActiveRecord::Base
  validates :tag, presence: true, uniqueness: true
  belongs_to :kind
  belongs_to :vendor
  belongs_to :user
end
