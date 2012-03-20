class UsersPackage < ActiveRecord::Base
  validates_uniqueness_of :user_id
  
  belongs_to :user
  belongs_to :package
end
