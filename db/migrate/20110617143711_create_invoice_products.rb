class CreateInvoiceProducts < ActiveRecord::Migration
  def self.up
    create_table :invoice_products do |t|
      t.integer :invoice_id
      t.integer :product_id
      t.float :price
      t.integer :quantity
      t.integer :discount
      t.integer :total

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_products
  end
end
