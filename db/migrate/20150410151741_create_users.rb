class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.belongs_to :department, index: true
      t.boolean :login
      t.boolean :admin
      t.integer :old_id

      t.timestamps null: false
    end
    add_foreign_key :users, :departments
  end
end
