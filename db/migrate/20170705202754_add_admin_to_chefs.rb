class AddAdminToChefs < ActiveRecord::Migration[5.0]
  def change
  	add_column :chefs, :name, :boolean, default: false
  end
end
