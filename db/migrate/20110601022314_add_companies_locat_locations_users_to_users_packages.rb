class AddCompaniesLocatLocationsUsersToUsersPackages < ActiveRecord::Migration
  def self.up
    add_column :users_packages, :companies, :integer
    add_column :users_packages, :locations, :integer
    add_column :users_packages, :users, :integer
  end

  def self.down
    remove_column :users_packages, :companies
    remove_column :users_packages, :locations
    remove_column :users_packages, :users
  end
end
