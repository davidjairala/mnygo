class RemoveProductIdFromProductsCategories < ActiveRecord::Migration
  def self.up
    remove_column :products_categories, :product_id
  end

  def self.down
    add_column :products_categories, :product_id, :integer
  end
end
