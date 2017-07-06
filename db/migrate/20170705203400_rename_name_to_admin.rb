class RenameNameToAdmin < ActiveRecord::Migration[5.0]
  def change
  	rename_column :chefs, :name, :admin
  end
end
