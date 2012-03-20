class Invoice < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :customer_id, :code, :user_id
  
  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :customer
  belongs_to :user
  
  has_many :invoice_products
  
  def get_subtotal(items)
    subtotal = 0
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end
    
    return subtotal
  end
  
  def get_tax(items, customer_id)
    tax = 0
    
    customer = Customer.find(customer_id)
    
    if(customer)
      if(customer.taxable == "1")
        for item in items
          if(item and item != "")
            parts = item.split("|BRK|")
        
            id = parts[0]
            quantity = parts[1]
            price = parts[2]
            discount = parts[3]
        
            total = price.to_f * quantity.to_i
            total -= total * (discount.to_f / 100)
        
            begin
              product = Product.find(id.to_i)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end

                if(product.tax2 and product.tax2 > 0)
                  tax += total * (product.tax2 / 100)
                end

                if(product.tax3 and product.tax3 > 0)
                  tax += total * (product.tax3 / 100)
                end
              end
            rescue
            end
          end
        end
      end
    end
    
    return tax
  end
  
  def delete_products()
    invoice_products = InvoiceProduct.find(:all, :conditions => {:invoice_id => self.id})
    
    for ip in invoice_products
      ip.destroy
    end
  end
  
  def add_products(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        total = price.to_f * quantity.to_i
        total -= total * (discount.to_f / 100)
        
        begin
          product = Product.find(id.to_i)
          
          new_invoice_product = InvoiceProduct.new(:invoice_id => self.id, :product_id => product.id, :price => price.to_f, :quantity => quantity.to_i, :discount => discount.to_f, :total => total.to_f)
          new_invoice_product.save
        rescue
        end
      end
    end
  end
  
  def identifier
    return "#{self.code} - #{self.customer.name}"
  end
  
  def get_products
    products = []
    invoice_products = InvoiceProduct.find(:all, :conditions => {:invoice_id => self.id})
    
    for ip in invoice_products
      ip.product[:curr_price] = ip.price
      ip.product[:curr_quantity] = ip.quantity
      ip.product[:curr_discount] = ip.discount
      ip.product[:curr_total] = ip.total
      
      products.push(ip.product)
    end
    
    return products
  end
  
  def get_invoice_products
    invoice_products = InvoiceProduct.find(:all, :conditions => {:invoice_id => self.id})
    
    return invoice_products
  end
  
  def products_lines
    products = []
    invoice_products = InvoiceProduct.find(:all, :conditions => {:invoice_id => self.id})
    
    for ip in invoice_products
      ip.product[:curr_price] = ip.price
      ip.product[:curr_quantity] = ip.quantity
      ip.product[:curr_discount] = ip.discount
      ip.product[:curr_total] = ip.total
      
      products.push("#{ip.product.id}|BRK|#{ip.product.curr_quantity}|BRK|#{ip.product.curr_price}|BRK|#{ip.product.curr_discount}")
    end
    
    return products.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Processed"
    else
      return "Not yet processed"
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Yes"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1")
      return "Yes"
    else
      return "No"
    end
  end
  
  # Process the invoice
  def process
    if(self.processed == "1" or self.processed == true)
      invoice_products = InvoiceProduct.find(:all, :conditions => {:invoice_id => self.id})
    
      for ip in invoice_products
        product = ip.product
        
        if(product.quantity)
          if(self.return == "0")
            ip.product.quantity -= ip.quantity
          else
            ip.product.quantity += ip.quantity
          end
          ip.product.save
        end
      end
      
      self.date_processed = Time.now
      self.save
    end
  end
  
  # Color for processed or not
  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
end