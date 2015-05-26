class CreateKinds < ActiveRecord::Migration
  def change
    create_table :kinds do |t|
      t.text :description
      t.integer :old_id

      t.timestamps null: false
    end
  end
end
