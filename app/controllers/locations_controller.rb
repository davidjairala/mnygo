include UsersHelper
include CompaniesHelper

class LocationsController < ApplicationController
  before_filter :checkLogin, :checkCompanies
  
  # Show locations for a company
  def list_locations
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Locations"
  
    if(@company.can_view(getUser()))
      @locations = Location.find(:all, :conditions => {:company_id => @company.id}, :order => "name")
    else
      errPerms()
    end
  end
  
  # GET /locations
  # GET /locations.xml
  def index
    @companies = Company.find(:all, :conditions => {:user_id => getUserId()}, :order => "name")
    @path = 'locations'
    @pagetitle = "Locations"
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    @pagetitle = "Locations - #{@location.name}"
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @pagetitle = "New location"
    @location = Location.new
    @company = Company.find(params[:company_id])
    @location.company_id = @company.id
    @location[:website] = 'http://'
    
    # Check package limits
    @locations_left_i = getUser().locations_left
    @locations_left = getUser().print_locations_left
    @locations_left_class = getUser().locations_left_class
    
    # Check if the user can use the company
    if(not @company.can_view(getUser()))
      redirect_to '/err_perms'
    end
  end

  # GET /locations/1/edit
  def edit
    @pagetitle = "Edit location"
    @location = Location.find(params[:id])
    @company = @location.company
    @location.company_id = @company.id
    @edit = true
  end

  # POST /locations
  # POST /locations.xml
  def create
    @pagetitle = "New location"
    @location = Location.new(params[:location])
    @company = Company.find(params[:location][:company_id])
    
    @locations_left_i = getUser().locations_left
    @locations_left = getUser().print_locations_left
    @locations_left_class = getUser().locations_left_class
    
    # Check package limits
    if(@locations_left_i <= 0 and @locations_left_i > -1000)
      flash[:error] = "You have created the most locations you can within your package.  Please select another package to create more locations."
      redirect_to("/pricing")
    else
      # Check if the user can use the company
      if(not @company.can_view(getUser()))
        redirect_to '/err_perms'
      else
        respond_to do |format|
          if @location.save
            format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
            format.xml  { render :xml => @location, :status => :created, :location => @location }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
          end
        end
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @pagetitle = "Edit location"
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    company_id = @location[:company_id]
    @location.destroy

    respond_to do |format|
      format.html { redirect_to("/companies/locations/" + company_id.to_s) }
      format.xml  { head :ok }
    end
  end
end
