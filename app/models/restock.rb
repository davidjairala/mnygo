class Restock < ActiveRecord::Base
  validates_presence_of :company_id, :product_id, :supplier_id, :quantity, :when, :received
  validates_numericality_of :quantity
  
  belongs_to :company
  belongs_to :product
  belongs_to :supplier
  
  def get_received
    if(self.received == "1" or self.received == true)
      return true
    end
  end
  
  def get_received_str
    if(self.get_received)
      return "Processed"
    else
      return "Not yet processed"
    end
  end
  
  def link
    if(self.code != "")
        code = self.code + " - "
    end
    
    code += "Supplier: " + self.supplier.name + " - Quantity: " + self.quantity.to_s
  end
  
  # Process the restock
  def process
    if(self.get_received)
      if(not self.product.quantity)
        self.product.quantity = 0
      end
      
      self.product.quantity += self.quantity
      self.product.save
      
      self.already_processed = "processed"
      self.save
    end
  end
  
  def get_processed
    if(self.already_processed == "processed")
      return true
    end
  end
  
  def get_processed_str
    if(self.get_processed)
      return "Processed"
    else
      return "Not yet processed"
    end
  end
  
  def get_code
    code = ""
    
    if(self.product.code and self.product.code != "")
      code = self.product.code + "-"
    end
    
    code += self.product.id.to_s + "-" + generate_guid()
  end
end