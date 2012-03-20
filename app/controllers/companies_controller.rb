include ApplicationHelper
include UsersHelper
include CompaniesHelper

class CompaniesController < ApplicationController
  before_filter :checkLogin
  
  # Export company to CSV
  def export
    @company = Company.find(params[:id])
    @customers = @company.get_customers()
    @divisions = @company.get_report_divisions()
    @locations = @company.get_report_locations()
    @products_categories = ProductsCategory.find(:all, :conditions => {:company_id => @company.id})
    @products = Product.find(:all, :conditions => {:company_id => @company.id})
    @suppliers = Supplier.find(:all, :conditions => {:company_id => @company.id})
    @products_kits = ProductsKit.find(:all, :conditions => {:company_id => @company.id})
    @invoices = Invoice.find(:all, :conditions => {:company_id => @company.id})
    @company_users = CompanyUser.find(:all, :conditions => {:company_id => @company.id})
    
    respond_to do |format|
      format.csv do
        render_csv("export_#{@company.id}")
      end
    end
  end
    
  # GET /companies
  # GET /companies.xml
  def index
    @pagetitle = 'My companies'
    @companies = getUser().get_companies()
    @user_package = UsersPackage.find(:first, :conditions => {:user_id => getUserId()})
    
    if(not @user_package)
      flash[:error] = 'Please first pick a pricing plan.'
      redirect_to '/pricing'
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])
    set_company(@company)
    
    @pagetitle = @company[:name]
    @locations = Location.find(:all, :conditions => {:company_id => @company.id})
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @pagetitle = 'New company'
    @company = Company.new
    @company[:website] = 'http://'
    
    # Check package limits
    @companies_left_i = getUser().companies_left
    @companies_left = getUser().print_companies_left
    @companies_left_class = getUser().companies_left_class
  end

  # GET /companies/1/edit
  def edit
    @pagetitle = 'Edit company'
    @company = Company.find(params[:id])
    @edit = true
    
    if(not @company.own(getUser()))
      redirect_to '/err_perms'
    end
  end

  # POST /companies
  # POST /companies.xml
  def create
    @pagetitle = 'New company'
    @company = Company.new(params[:company])
    @company[:user_id] = getUserId()
    
    @companies_left_i = getUser().companies_left
    @companies_left = getUser().print_companies_left
    @companies_left_class = getUser().companies_left_class
    
    # Check package limits
    if(@companies_left_i <= 0 and @companies_left_i > -1000)
      flash[:error] = "You have created the most companies you can within your package.  Please select another package to create more companies."
      redirect_to("/pricing")
    else
      respond_to do |format|
        # Should we upload a logo?
        if(params[:company][:logo])
          if(not checkFileExtension(params[:company][:logo], imgTypes()))
            flash[:error] = "The logo you tried to upload doesn't have the correct format.  Please upload a GIF, JPG, or PNG image."
            format.html { render :action => "edit" }
          else
            params[:company][:logo] = @company.upload_logo(params[:company][:logo])
          end
        end

        if @company.save
          # Create company user for the user
          new_company_user = CompanyUser.new(:company_id => @company.id, :user_id => getUserId())
          new_company_user.save

          format.html { redirect_to(@company, :notice => 'Company was successfully created.') }
          format.xml  { render :xml => @company, :status => :created, :location => @company }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @pagetitle = 'Edit company'
    @company = Company.find(params[:id])

    respond_to do |format|
      # Should we upload a logo?
      if(params[:company][:logo])
        if(not checkFileExtension(params[:company][:logo], imgTypes()))
          flash[:error] = "The logo you tried to upload doesn't have the correct format.  Please upload a GIF, JPG, or PNG image."
          format.html { render :action => "edit" }
        else
          params[:company][:logo] = @company.upload_logo(params[:company][:logo])
        end
      end
      
      if @company.update_attributes(params[:company])
        format.html { redirect_to(@company, :notice => 'Company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    
    if(not @company.own(getUser()))
      redirect_to '/err_perms'
    else
      @company_users = CompanyUser.find(:all, :conditions => {:company_id => @company.id})
      
      for cu in @company_users
        cu.destroy
      end
      
      @company.delete_logo()
      @company.destroy

      redirect_to(companies_url)
    end
  end
end
