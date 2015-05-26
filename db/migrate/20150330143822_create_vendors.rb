class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :title
      t.string :address
      t.string :contact_person
      t.string :email
      t.string :phone
      t.integer :old_id

      t.timestamps null: false
    end
  end
end
