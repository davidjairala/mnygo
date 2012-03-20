class AddCompanyIdToProductsKits < ActiveRecord::Migration
  def self.up
    add_column :products_kits, :company_id, :integer
  end

  def self.down
    remove_column :products_kits, :company_id
  end
end
