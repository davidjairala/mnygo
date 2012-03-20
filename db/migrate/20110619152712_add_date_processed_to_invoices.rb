class AddDateProcessedToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :date_processed, :datetime
  end

  def self.down
    remove_column :invoices, :date_processed
  end
end
