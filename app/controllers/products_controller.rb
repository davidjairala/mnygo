include UsersHelper
include CompaniesHelper

class ProductsController < ApplicationController
  before_filter :checkLogin, :checkCompanies
  
  # Autocomplete for products
  def ac_products
    @products = Product.find(:all, :conditions => ["company_id = ? AND (code LIKE ? OR name LIKE ?)", params[:company_id], "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # Autocomplete for categories
  def ac_categories
    @categories = ProductsCategory.find(:all, :conditions => ["company_id = ? AND category LIKE ?", params[:company_id], "%" + params[:q] + "%"])
    
    render :layout => false
  end
  
  # List products for a company
  def list_products
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Products"
  
    if(@company.can_view(getUser()))
      if(params[:restock])
        @products = Product.paginate(:page => params[:page], :order => 'name', :conditions => ["company_id = ? AND quantity <= reorder", @company.id])
        @view_restock = true
      else
        if(params[:q] and params[:q] != "")
          fields = ["name", "code", "category", "description", "comments"]
        
          q = params[:q].strip
          @q_org = q
        
          query = str_sql_search(q, fields)
        
          @products = Product.paginate(:page => params[:page], :order => 'name', :conditions => ["company_id = ? AND (#{query})", @company.id])
        else
          @products = Product.paginate(:page => params[:page], :order => 'name', :conditions => {:company_id => @company.id})
        end
      end
    else
      errPerms()
    end
  end
  
  # GET /products
  # GET /products.xml
  def index
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'products'
    @pagetitle = "Products"
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    @pagetitle = "Products - #{@product.name}"
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @pagetitle = "New product"
    
    @product = Product.new
    @product[:cost] = 0
    @product[:company_id] = params[:company_id]
    @company = Company.find(params[:company_id])
    @suppliers = @company.get_suppliers()
    
    @product[:tax1_name] = @company.get_last_tax_name(1)
    @product[:tax2_name] = @company.get_last_tax_name(2)
    @product[:tax2_name] = @company.get_last_tax_name(3)
    
    if(@company.get_last_tax(1))
      @product[:tax1] = @company.get_last_tax(1)
    else
      @product[:tax1] = 0
    end
    
    if(@company.get_last_tax(2))
      @product[:tax2] = @company.get_last_tax(2)
    else
      @product[:tax2] = 0
    end
    
    if(@company.get_last_tax(3))
      @product[:tax3] = @company.get_last_tax(3)
    else
      @product[:tax3] = 0
    end
    
    if(not @company.can_view(getUser()))
      errPerms()
    end
  end

  # GET /products/1/edit
  def edit
    @pagetitle = "Edit product"
    
    @product = Product.find(params[:id])
    @company = @product.company
    @suppliers = @company.get_suppliers()
  end

  # POST /products
  # POST /products.xml
  def create
    @pagetitle = "New product"
    
    @product = Product.new(params[:product])
    @company = Company.find(params[:product][:company_id])
    @suppliers = @company.get_suppliers()
    
    if(@product[:tax1] == nil)
      @product[:tax1] = 0
    end
    
    if(@product[:tax2] == nil)
      @product[:tax2] = 0
    end
    
    if(@product[:tax3] == nil)
      @product[:tax3] = 0
    end
    
    if(@company.can_view(getUser()))
      respond_to do |format|
        if @product.save
          
          @product.add_category(@product[:category])
          
          format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
          format.xml  { render :xml => @product, :status => :created, :location => @product }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        end
      end
    else
      errPerms()
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @pagetitle = "Edit product"
    
    @product = Product.find(params[:id])
    @company = @product.company
    @suppliers = @company.get_suppliers()

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    
    # Erase from product kits
    kits_products = KitsProduct.find(:all, :conditions => {:product_id => @product[:id]})
    
    for product in kits_products
      product.destroy
    end
    
    company_id = @product[:company_id]
    @product.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/products/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end
end
