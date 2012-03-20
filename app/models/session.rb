class Session < ActiveRecord::Base
  self.per_page = 20
  
  belongs_to :user
end
