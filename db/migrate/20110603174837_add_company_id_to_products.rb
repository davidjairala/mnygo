class AddCompanyIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :company_id, :integer
  end

  def self.down
    remove_column :products, :company_id
  end
end
