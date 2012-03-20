class ProductsCategory < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :category
  
  belongs_to :company
end
