class AddMobileToKinds < ActiveRecord::Migration
  def change
    add_column :kinds, :mobile, :boolean, :default => :false
  end
end
