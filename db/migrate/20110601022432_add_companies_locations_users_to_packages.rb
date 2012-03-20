class AddCompaniesLocationsUsersToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :companies, :integer
    add_column :packages, :locations, :integer
    add_column :packages, :users, :integer

    UsersPackage.create :user_id => 1, :package_id => 1, :start_date => '2012-03-01', :end_date => '2020-12-31', :companies => 1, :locations => 1, :users => 1
  end

  def self.down
    remove_column :packages, :companies
    remove_column :packages, :locations
    remove_column :packages, :users
  end
end
