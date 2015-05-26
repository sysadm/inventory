class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :tag
      t.string :model
      t.string :serial
      t.text :notes
      t.date :date_of_purchase
      t.date :date_of_registration
      t.references :kind, index: true
      t.references :vendor, index: true
      t.references :user, index: true
      t.integer :old_id

      t.timestamps null: false
    end
    add_foreign_key :inventories, :kinds
    add_foreign_key :inventories, :vendors
    add_foreign_key :inventories, :users
  end
end
