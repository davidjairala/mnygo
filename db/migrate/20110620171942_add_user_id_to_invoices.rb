class AddUserIdToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :user_id, :integer
  end

  def self.down
    remove_column :invoices, :user_id
  end
end
