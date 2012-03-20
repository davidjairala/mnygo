include UsersHelper
include CustomersHelper
include ProductsHelper

class InvoicesController < ApplicationController
  before_filter :checkLogin, :checkProducts
  
  # Add kit to invoice
  def add_kit
    @kit = ProductsKit.find(params[:kit_id])
    @discount = params[:discount] || 0
    
    if(not @kit)
      render :text => "no_kit"
    else
      render :layout => false
    end
  end
  
  # Export invoice to PDF
  def pdf
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html { redirect_to("/invoices/pdf/#{@invoice.id}.pdf") }
      format.pdf { render :layout => false }
    end
  end
  
  # Process an invoice
  def do_process
    @invoice = Invoice.find(params[:id])
    @invoice[:processed] = true
    @invoice.process
    
    flash[:notice] = "The invoice order has been processed."
    redirect_to @invoice
  end
  
  # Do send invoice via email
  def do_email
    @invoice = Invoice.find(params[:id])
    @email = params[:email]
    
    Notifier.invoice(@email, @invoice).deliver
    
    flash[:notice] = "The invoice has been sent successfully."
    redirect_to "/invoices/#{@invoice.id}"
  end
  
  # Send invoice via email
  def email
    @invoice = Invoice.find(params[:id])
    @company = @invoice.company
  end
  
  # List items
  def list_items
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_arr = []
    @products = []
    i = 0
    
    for item in items
      if item != ""
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        product = Product.find(id.to_i)
        product[:i] = i
        product[:quantity] = quantity.to_i
        product[:price] = price.to_f
        product[:discount] = discount.to_f
        
        total = product[:price] * product[:quantity]
        total -= total * (product[:discount] / 100)
        
        product[:curr_total] = total
        
        @products.push(product)
      end
      
      i += 1
    end
    
    render :layout => false
  end
  
  # Autocomplete for product kits
  def ac_kit
    @kits = ProductsKit.find(:all, :conditions => ["company_id = ? AND (name LIKE ? OR description LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
    
    render :layout => false
  end
  
  # Autocomplete for products
  def ac_products
    @products = Product.find(:all, :conditions => ["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Autocomplete for users
  def ac_user
    company_users = CompanyUser.find(:all, :conditions => {:company_id => params[:company_id]})
    user_ids = []
    
    for cu in company_users
      user_ids.push(cu.user_id)
    end
    
    @users = User.find(:all, :conditions => ["id IN (#{user_ids.join(",")}) AND (email LIKE ? OR username LIKE ?)", "%" + params[:q] + "%", "%" + params[:q] + "%"])
    alr_ids = []
    
    for user in @users
      alr_ids.push(user.id)
    end
    
    if(not alr_ids.include?(getUserId()))
      @users.push(getUser())
    end
   
    render :layout => false
  end
  
  # Autocomplete for customers
  def ac_customers
    @customers = Customer.find(:all, :conditions => ["company_id = ? AND (email LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Show invoices for a company
  def list_invoices
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Invoices"
    @filters_display = "block"
    
    @locations = Location.find(:all, :conditions => {:company_id => @company.id}, :order => "name ASC")
    @divisions = Division.find(:all, :conditions => {:company_id => @company.id}, :order => "name ASC")
    
    if(params[:location] and params[:location] != "")
      @sel_location = params[:location]
    end
    
    if(params[:division] and params[:division] != "")
      @sel_division = params[:division]
    end
  
    if(@company.can_view(getUser()))
      if(params[:ac_customer] and params[:ac_customer] != "")
        @customer = Customer.find(:first, :conditions => {:company_id => @company.id, :name => params[:ac_customer].strip})
        
        if @customer
          @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any invoices for that customer."
          redirect_to "/companies/invoices/#{@company.id}"
        end
      elsif(params[:customer] and params[:customer] != "")
        @customer = Customer.find(params[:customer])
        
        if @customer
          @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :customer_id => @customer.id}, :order => "id DESC")
        else
          flash[:error] = "We couldn't find any invoices for that customer."
          redirect_to "/companies/invoices/#{@company.id}"
        end
      elsif(params[:location] and params[:location] != "" and params[:division] and params[:division] != "")
        @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location], :division_id => params[:division]}, :order => "id DESC")
      elsif(params[:location] and params[:location] != "")
        @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :location_id => params[:location]}, :order => "id DESC")
      elsif(params[:division] and params[:division] != "")
        @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id, :division_id => params[:division]}, :order => "id DESC")
      else
        if(params[:q] and params[:q] != "")
          fields = ["description", "comments", "code"]

          q = params[:q].strip
          @q_org = q

          query = str_sql_search(q, fields)

          @invoices = Invoice.paginate(:page => params[:page], :order => 'id DESC', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @invoices = Invoice.paginate(:page => params[:page], :conditions => {:company_id => @company.id}, :order => "id DESC")
          @filters_display = "none"
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /invoices
  # GET /invoices.xml
  def index
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'invoices'
    @pagetitle = "Invoices"
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])
    @customer = @invoice.customer
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @pagetitle = "New invoice"
    @action_txt = "Create"
    
    @invoice = Invoice.new
    @invoice[:code] = "I_#{generate_guid()}"
    @invoice[:processed] = false
    
    @company = Company.find(params[:company_id])
    @invoice.company_id = @company.id
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @ac_user = getUsername()
    @invoice[:user_id] = getUserId()
  end

  # GET /invoices/1/edit
  def edit
    @pagetitle = "Edit invoice"
    @action_txt = "Update"
    
    @invoice = Invoice.find(params[:id])
    @company = @invoice.company
    @ac_customer = @invoice.customer.name
    @ac_user = @invoice.user.username
    
    @products_lines = @invoice.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @pagetitle = "New invoice"
    @action_txt = "Create"
    
    items = params[:items].split(",")
    
    @invoice = Invoice.new(params[:invoice])
    
    @company = Company.find(params[:invoice][:company_id])
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @invoice[:subtotal] = @invoice.get_subtotal(items)
    
    begin
      @invoice[:tax] = @invoice.get_tax(items, @invoice[:customer_id])
    rescue
      @invoice[:tax] = 0
    end
    
    @invoice[:total] = @invoice[:subtotal] + @invoice[:tax]
    
    if(params[:invoice][:user_id] and params[:invoice][:user_id] != "")
      curr_seller = User.find(params[:invoice][:user_id])
      @ac_user = curr_seller.username
    end

    respond_to do |format|
      if @invoice.save
        # Create products for kit
        @invoice.add_products(items)
        
        # Check if we gotta process the invoice
        @invoice.process()
        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @pagetitle = "Edit invoice"
    @action_txt = "Update"
    
    items = params[:items].split(",")
    
    @invoice = Invoice.find(params[:id])
    @company = @invoice.company
    
    if(params[:ac_customer] and params[:ac_customer] != "")
      @ac_customer = params[:ac_customer]
    else
      @ac_customer = @invoice.customer.name
    end
    
    @products_lines = @invoice.products_lines
    
    @locations = @company.get_locations()
    @divisions = @company.get_divisions()
    
    @invoice[:subtotal] = @invoice.get_subtotal(items)
    @invoice[:tax] = @invoice.get_tax(items, @invoice[:customer_id])
    @invoice[:total] = @invoice[:subtotal] + @invoice[:tax]

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        # Create products for kit
        @invoice.delete_products()
        @invoice.add_products(items)
        
        # Check if we gotta process the invoice
        @invoice.process()
        
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    company_id = @invoice[:company_id]
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/invoices/" + company_id.to_s) }
    end
  end
end
