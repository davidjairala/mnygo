class Division < ActiveRecord::Base
  validates_presence_of :company_id, :name
  
  belongs_to :company
  belongs_to :location
  
  has_many :invoices
end
