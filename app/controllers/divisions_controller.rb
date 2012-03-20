include UsersHelper
include CompaniesHelper

class DivisionsController < ApplicationController
  before_filter :checkLogin, :checkCompanies
  
  # Show division for a company
  def list_divisions
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Divisions"
  
    if(@company.can_view(getUser()))
      @divisions = Division.find(:all, :conditions => {:company_id => @company.id}, :order => "name")
    else
      errPerms()
    end
  end
  
  # GET /divisions
  # GET /divisions.xml
  def index
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'divisions'
    @pagetitle = "Divisions"
  end

  # GET /divisions/1
  # GET /divisions/1.xml
  def show
    @division = Division.find(params[:id])
  end

  # GET /divisions/new
  # GET /divisions/new.xml
  def new
    @pagetitle = "New division"
    
    @division = Division.new
    
    @company = Company.find(params[:company_id])
    @division.company_id = @company.id
    
    @locations = @company.get_locations()
  end

  # GET /divisions/1/edit
  def edit
    @pagetitle = "Edit division"
    
    @division = Division.find(params[:id])
    
    @company = Company.find(@division[:company_id])
    
    @locations = @company.get_locations()
  end

  # POST /divisions
  # POST /divisions.xml
  def create
    @pagetitle = "New division"
    
    @division = Division.new(params[:division])
    
    @company = Company.find(params[:division][:company_id])
    @division.company_id = @company.id
    
    @locations = @company.get_locations()

    respond_to do |format|
      if @division.save
        format.html { redirect_to(@division, :notice => 'Division was successfully created.') }
        format.xml  { render :xml => @division, :status => :created, :location => @division }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @division.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /divisions/1
  # PUT /divisions/1.xml
  def update
    @pagetitle = "Edit division"
    
    @division = Division.find(params[:id])
    
    @company = Company.find(@division[:company_id])
    
    @locations = @company.get_locations()

    respond_to do |format|
      if @division.update_attributes(params[:division])
        format.html { redirect_to(@division, :notice => 'Division was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @division.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /divisions/1
  # DELETE /divisions/1.xml
  def destroy
    @division = Division.find(params[:id])
    company_id = @location[:company_id]
    @division.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/divisions/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end
end
