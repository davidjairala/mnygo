class Package < ActiveRecord::Base
  validates_presence_of :title, :price, :description, :companies, :locations, :users
  
  has_many :users_packages
  
  def register(user)
    start_date = Time.now
    end_date = Time.now + 1.year
    # Check if we already have a user_package
    user_package = UsersPackage.find(:first, :conditions => {:user_id => user.id, :package_id => self.id})
    
    if(not user_package)
      user_package = UsersPackage.new(
        :user_id => user.id,
        :package_id => self.id,
        :start_date => start_date,
        :end_date => end_date,
        :companies => self.companies,
        :locations => self.locations,
        :users => self.users
      )
    else
      user_package[:start_date] = start_date
      user_package[:end_date] = end_date
      user_package[:package_id] = self.id
      user_package[:companies] = self.companies
      user_package[:locations] = self.locations
      user_package[:users] = self.users
    end
    
    user_package.save
  end
end
