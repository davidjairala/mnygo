class ProductsKit < ActiveRecord::Base
  validates_presence_of :name
  
  belongs_to :company
  
  has_many :kits_products
  
  def delete_products
    products = KitsProduct.find(:all, :conditions => {:product_kit_id => self.id})
    
    for product in products
      product.destroy
    end
  end
  
  def add_products(items, quantities)
    i = 0
    
    for item in items
      if(item and item != "")
        new_kit_product = KitsProduct.new(:product_kit_id => self.id, :product_id => item.to_i, :quantity => quantities[i])
        new_kit_product.save
      end
      
      i += 1
    end
  end
  
  def get_kits_products()
    kits_products = KitsProduct.find(:all, :conditions => {:product_kit_id => self.id})
    
    return kits_products
  end
  
  def products
    kits_products = KitsProduct.find(:all, :conditions => {:product_kit_id => self.id})
    products = []
    
    for kp in kits_products
      product = Product.find(kp.product_id)
      product.quantity = kp.quantity
      products.push(product)
    end
    
    return products
  end
  
  def products_ids
    products = self.products
    ids = []
    
    for product in products
      ids.push(product.id)
    end
    
    return ids.join(",")
  end
  
  def products_quantities
    products = self.products
    quantities = []
    
    for product in products
      quantities.push(product.quantity)
    end
    
    return quantities.join(",")
  end
  
  def price
    products = self.products
    price = 0
    
    for product in products
      price += product.price * product.quantity
    end
    
    return price
  end
  
  def cost
    products = self.products
    cost = 0
    
    for product in products
      cost += product.cost * product.quantity
    end
    
    return cost
  end
  
  def profit
    cost = self.cost
    price = self.price
    total = price - cost
    
    return total
  end
end
