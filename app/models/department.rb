class Department < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  has_many :users

end
