class KitsProduct < ActiveRecord::Base
  validates_presence_of :product_kit_id, :product_id, :quantity
  
  belongs_to :products_kit, :foreign_key => "product_kit_id"
  belongs_to :product
end
