class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :title
      t.integer :old_id

      t.timestamps null: false
    end
  end
end
