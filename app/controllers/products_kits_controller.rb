include UsersHelper
include ProductsHelper
include CompaniesHelper

class ProductsKitsController < ApplicationController
  before_filter :checkLogin, :checkProducts, :checkCompanies
  
  # List items
  def list_items
    @company = Company.find(params[:company_id])
    items = params[:items]
    items = items.split(",")
    items_quantities = params[:items_quantities]
    items_quantities = items_quantities.split(",")
    items_arr = []
    @products = []
    i = 0
    
    for item in items
      if item != ""
        product = Product.find(item.to_i)
        product[:quantity] = items_quantities[i]
        @products.push(product)
      end
      
      i += 1
    end
    
    render :layout => false
  end
  
  # List product kits for a company
  def list_products_kits
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Product kits"
    
    if(@company.can_view(getUser()))
      @products_kits = ProductsKit.paginate(:page => params[:page], :order => 'name', :conditions => {:company_id => @company.id})
    else
      errPerms()
    end
  end
  
  # GET /products_kits
  # GET /products_kits.xml
  def index
    @pagetitle = "Product kits"
    
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'products_kits'
  end

  # GET /products_kits/1
  # GET /products_kits/1.xml
  def show
    @products_kit = ProductsKit.find(params[:id])
    @pagetitle = "Product kits - #{@products_kit.name}"
  end

  # GET /products_kits/new
  # GET /products_kits/new.xml
  def new
    @pagetitle = "New product kit"
    
    @action = "Create"

    @company = Company.find(params[:company_id])
    @products_kit = ProductsKit.new
    @products_kit[:company_id] = params[:company_id]
  end

  # GET /products_kits/1/edit
  def edit
    @pagetitle = "Edit product kit"
    
    @action = "Update"
    
    @products_kit = ProductsKit.find(params[:id])
    @company = Company.find(@products_kit[:company_id])
    @products_ids = @products_kit.products_ids
    @products_quantities = @products_kit.products_quantities
  end

  # POST /products_kits
  # POST /products_kits.xml
  def create
    @pagetitle = "New product kit"
    
    @action = "Create"
    
    @company = Company.find(params[:products_kit][:company_id])
    @products_kit = ProductsKit.new(params[:products_kit])

    respond_to do |format|
      if @products_kit.save
        # Create products for kit
        items = params[:items].split(",")
        quantities = params[:items_quantities].split(",")
        @products_kit.add_products(items, quantities)
        
        format.html { redirect_to(@products_kit, :notice => 'Products kit was successfully created.') }
        format.xml  { render :xml => @products_kit, :status => :created, :location => @products_kit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @products_kit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products_kits/1
  # PUT /products_kits/1.xml
  def update
    @pagetitle = "Edit product kit"
    
    @action = "Update"
    
    @products_kit = ProductsKit.find(params[:id])
    @company = Company.find(@products_kit[:company_id])

    respond_to do |format|
      if @products_kit.update_attributes(params[:products_kit])
        # Update products for kit
        @products_kit.delete_products
        
        items = params[:items].split(",")
        quantities = params[:items_quantities].split(",")
        @products_kit.add_products(items, quantities)
        
        format.html { redirect_to(@products_kit, :notice => 'Products kit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @products_kit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products_kits/1
  # DELETE /products_kits/1.xml
  def destroy
    @products_kit = ProductsKit.find(params[:id])
    company_id = @products_kit[:company_id]
    @products_kit.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/products_kits/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end
end
