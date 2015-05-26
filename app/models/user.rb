class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  belongs_to :department
  has_many :inventories

  default_scope { order(:last_name, :username) }

  class << self
    def ldap_import
      %x{rake multitel:users:import >> log/ldap_users_import.log}
    end
    handle_asynchronously :ldap_import
  end

  def is_admin?
    self.admin
  end
  def read_only?
    self.read_only
  end
  def forget_me!
    true
  end
end
