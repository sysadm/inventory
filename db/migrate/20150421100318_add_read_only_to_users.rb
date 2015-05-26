class AddReadOnlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :read_only, :boolean, default: false
  end
end
