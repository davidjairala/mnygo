include UsersHelper
include CompaniesHelper

class RestocksController < ApplicationController
  before_filter :checkLogin, :checkCompanies
  
  # Reprocess order
  def do_process
    @restock = Restock.find(params[:id])
    @restock[:received] = true
    @restock.process
    
    flash[:notice] = "The restock order has been processed. + #{@restock.quantity}."
    redirect_to @restock
  end
  
  # List restocks for company
  def list_restocks
    @company = Company.find(params[:company_id])
    @product = Product.find(params[:product_id])
    
    @pagetitle = "#{@company.name} - #{@product.name} - Restock orders"
    
    if(@company.can_view(getUser()))
      @restocks = Restock.paginate(:page => params[:page], :order => 'id DESC', :conditions => {:product_id => @product[:id]})
    else
      errPerms()
    end
  end
  
  # GET /restocks
  # GET /restocks.xml
  def index
    redirect_to "/companies"
  end

  # GET /restocks/1
  # GET /restocks/1.xml
  def show
    @restock = Restock.find(params[:id])
    @pagetitle = "Restock orders - #{@restock.link}"
  end

  # GET /restocks/new
  # GET /restocks/new.xml
  def new
    @pagetitle = "New restock order"
    
    @company = Company.find(params[:company_id])
    
    @restock = Restock.new
    @restock[:company_id] = params[:company_id]
    @restock[:product_id] = params[:product_id]
    
    if(@restock.product.supplier)
      @restock[:supplier_id] = @restock.product.supplier.id
    end
    
    @restock[:received] = false
    @restock[:code] = @restock.get_code
    
    @suppliers = @company.get_suppliers()
  end

  # GET /restocks/1/edit
  def edit
    @pagetitle = "Edit restock order"
    
    @restock = Restock.find(params[:id])
    @restock[:received] = false
    
    @company = Company.find(@restock[:company_id])
    @suppliers = @company.get_suppliers()
  end

  # POST /restocks
  # POST /restocks.xml
  def create
    @pagetitle = "New restock order"
    
    @company = Company.find(params[:restock][:company_id])
    
    @restock = Restock.new(params[:restock])
    
    @suppliers = @company.get_suppliers()

    respond_to do |format|
      if @restock.save
        @restock.process
        
        format.html { redirect_to(@restock, :notice => 'Restock was successfully created.') }
        format.xml  { render :xml => @restock, :status => :created, :location => @restock }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @restock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /restocks/1
  # PUT /restocks/1.xml
  def update
    @pagetitle = "Edit restock order"
    
    @restock = Restock.find(params[:id])
    
    @company = Company.find(@restock[:company_id])
    @suppliers = @company.get_suppliers()

    respond_to do |format|
      if @restock.update_attributes(params[:restock])
        @restock.process
        
        format.html { redirect_to(@restock, :notice => 'Restock was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @restock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /restocks/1
  # DELETE /restocks/1.xml
  def destroy
    @restock = Restock.find(params[:id])
    @company = @restock.company
    @product = @restock.product
    @restock.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/restocks/#{@company.id}/#{@product.id}") }
      format.xml  { head :ok }
    end
  end
end
