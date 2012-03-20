class AddReturnToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :return, :string
  end

  def self.down
    remove_column :invoices, :return
  end
end
