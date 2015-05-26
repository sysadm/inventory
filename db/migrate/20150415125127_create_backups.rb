class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.string :file
      t.string :digest
      t.integer :size
      t.boolean :current

      t.timestamps null: false
    end
  end
end
