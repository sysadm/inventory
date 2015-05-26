class Admin < ActiveRecord::Base
  authenticates_with_sorcery!

  validates_uniqueness_of :email
  validates_presence_of :email, :password
  validates_confirmation_of :password
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def is_admin?
    true
  end
  def read_only?
    false
  end
end
