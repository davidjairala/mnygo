class AddCompanyIdToRestocks < ActiveRecord::Migration
  def self.up
    add_column :restocks, :company_id, :integer
  end

  def self.down
    remove_column :restocks, :company_id
  end
end
