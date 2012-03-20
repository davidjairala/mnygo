class AddCompanyIdToSupplier < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :company_id, :integer
  end

  def self.down
    remove_column :suppliers, :company_id
  end
end
