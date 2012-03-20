class ChangeNameInCustomers < ActiveRecord::Migration
  def self.up
    remove_column :customers, :first_name
    remove_column :customers, :last_name
    add_column :customers, :name, :string
  end

  def self.down
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    remove_column :customers, :name
  end
end
