class Product < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :name, :cost, :price, :company_id
  validates_numericality_of :cost, :price, :tax1, :tax2, :tax3
  
  belongs_to :company
  belongs_to :supplier
  
  has_many :kits_products
  has_many :restocks
  has_many :invoice_products
  
  def add_category(category_txt)
    if(self.category != nil)
      # Add category
      category = ProductsCategory.find(:first, :conditions => {:company_id => self.company.id, :category => category_txt})
      
      if(not category)
        category = ProductsCategory.new(:company_id => self.company.id, :category => category_txt)
        category.save
      end
    end
  end
  
  def tax()
    total = 0
    
    if(self.tax1 and self.tax1 > 0)
      total += self.price * (self.tax1 / 100)
    end
    
    if(self.tax2 and self.tax2 > 0)
      total += self.price * (self.tax2 / 100)
    end
    
    if(self.tax3 and self.tax3 > 0)
      total += self.price * (self.tax3 / 100)
    end
    
    return total
  end
  
  def total()
    total = self.price
    
    if(self.tax1 and self.tax1 > 0)
      total += self.price * (self.tax1 / 100)
    end
    
    if(self.tax2 and self.tax2 > 0)
      total += self.price * (self.tax2 / 100)
    end
    
    if(self.tax3 and self.tax3 > 0)
      total += self.price * (self.tax3 / 100)
    end
    
    return total
  end
  
  def profit()
    return self.price - self.cost
  end
  
  def full_name()
    if(self.code and self.code != "")
      name = self.code + ": " + self.name
    else
      name = self.name
    end
    
    return name
  end
end
