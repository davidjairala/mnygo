class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :company_id
      t.integer :location_id
      t.integer :division_id
      t.integer :customer_id
      t.text :description
      t.text :comments
      t.string :code
      t.float :subtotal
      t.float :tax
      t.float :total
      t.string :processed

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
