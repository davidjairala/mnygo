class ChangePriceQuantityDiscountInvoiceProduct < ActiveRecord::Migration
  def self.up
    change_column :invoice_products, :discount, :float
    change_column :invoice_products, :total, :float
  end

  def self.down
    change_column :invoice_products, :discount, :integer
    change_column :invoice_products, :total, :integer
  end
end
