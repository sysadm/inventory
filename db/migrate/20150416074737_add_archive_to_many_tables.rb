class AddArchiveToManyTables < ActiveRecord::Migration
  def change
    [:departments, :inventories, :kinds, :users, :vendors].each{|table|
      add_column table, :archive, :boolean, default: false
    }
  end
end
