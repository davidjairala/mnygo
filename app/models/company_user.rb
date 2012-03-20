class CompanyUser < ActiveRecord::Base
  validates_presence_of :company_id, :user_id
  
  belongs_to :company
  belongs_to :user
end
