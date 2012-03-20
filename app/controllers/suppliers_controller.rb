include UsersHelper
include CompaniesHelper

class SuppliersController < ApplicationController
  before_filter :checkLogin, :checkCompanies
  
  # Show suppliers for a company
  def list_suppliers
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Suppliers"
  
    if(@company.can_view(getUser()))
      if(params[:q] and params[:q] != "")
        fields = ["email", "name"]

        q = params[:q].strip
        @q_org = q

        query = str_sql_search(q, fields)

        @suppliers = Supplier.paginate(:page => params[:page], :order => 'name', :conditions => ["company_id = ? AND (#{query})", @company.id])
      else
        @suppliers = Supplier.paginate(:page => params[:page], :order => "name", :conditions => {:company_id => @company.id})
      end
    else
      errPerms()
    end
  end
  
  # GET /suppliers
  # GET /suppliers.xml
  def index
    @pagetitle = "Suppliers"
    
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'suppliers'
  end

  # GET /suppliers/1
  # GET /suppliers/1.xml
  def show
    @supplier = Supplier.find(params[:id])
    @pagetitle = "Suppliers - #{@supplier.name}"
  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @pagetitle = "New supplier"
    
    if(params[:company_id])
      @company = Company.find(params[:company_id])
    
      if(@company.can_view(getUser()))
        @supplier = Supplier.new
        @supplier.company_id = @company.id
      else
        errPerms()
      end
    else
      redirect_to('/companies')
    end
  end

  # GET /suppliers/1/edit
  def edit
    @pagetitle = "Edit supplier"
    
    @supplier = Supplier.find(params[:id])
  end

  # POST /suppliers
  # POST /suppliers.xml
  def create
    @pagetitle = "New supplier"
    
    @company = Company.find(params[:supplier][:company_id])
    @supplier = Supplier.new(params[:supplier])

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully created.') }
        format.xml  { render :xml => @supplier, :status => :created, :location => @supplier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @pagetitle = "Edit supplier"
    
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      if @supplier.update_attributes(params[:supplier])
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.xml
  def destroy
    @supplier = Supplier.find(params[:id])
    
    # Erase supplier id for products from supplier
    products = Product.find(:all, :conditions => {:supplier_id => @supplier[:id]})
    
    for product in products
      product.supplier_id = nil
      product.save
    end
    
    @company = @supplier.company
    @supplier.destroy

    respond_to do |format|
      format.html { redirect_to "/companies/suppliers/#{@company.id}" }
      format.xml  { head :ok }
    end
  end
end
