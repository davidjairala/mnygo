class InvoiceProduct < ActiveRecord::Base
  validates_presence_of :invoice_id, :product_id, :price, :quantity, :discount, :total
  
  belongs_to :invoice
  belongs_to :product
end
