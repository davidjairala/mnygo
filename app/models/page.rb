class Page < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :title, :title_clean
  validates_uniqueness_of :title_clean
end
