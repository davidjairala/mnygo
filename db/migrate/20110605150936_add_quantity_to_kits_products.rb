class AddQuantityToKitsProducts < ActiveRecord::Migration
  def self.up
    add_column :kits_products, :quantity, :integer
  end

  def self.down
    remove_column :kits_products, :quantity
  end
end
