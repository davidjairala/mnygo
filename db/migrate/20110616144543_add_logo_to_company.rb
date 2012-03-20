class AddLogoToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :logo, :string
  end

  def self.down
    remove_column :companies, :logo
  end
end
