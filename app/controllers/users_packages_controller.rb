include UsersHelper

class UsersPackagesController < ApplicationController
  before_filter :checkAdmin
  
  # GET /users_packages
  # GET /users_packages.xml
  def index
    @pagetitle = "User packages"
    
    @users_packages = UsersPackage.all
  end

  # GET /users_packages/1
  # GET /users_packages/1.xml
  def show
    @pagetitle = "View user package"
    
    @users_package = UsersPackage.find(params[:id])
  end

  # GET /users_packages/new
  # GET /users_packages/new.xml
  def new
    @pagetitle = "New user package"
    
    @users_package = UsersPackage.new
    @packages = Package.find(:all)
  end

  # GET /users_packages/1/edit
  def edit
    @pagetitle = "Edit user package"
    
    @users_package = UsersPackage.find(params[:id])
    @packages = Package.find(:all)
  end

  # POST /users_packages
  # POST /users_packages.xml
  def create
    @pagetitle = "New user package"
    
    @users_package = UsersPackage.new(params[:users_package])
    @packages = Package.find(:all)

    respond_to do |format|
      if @users_package.save
        format.html { redirect_to(@users_package, :notice => 'Users package was successfully created.') }
        format.xml  { render :xml => @users_package, :status => :created, :location => @users_package }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @users_package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users_packages/1
  # PUT /users_packages/1.xml
  def update
    @pagetitle = "Edit user package"
    
    @users_package = UsersPackage.find(params[:id])
    @packages = Package.find(:all)

    respond_to do |format|
      if @users_package.update_attributes(params[:users_package])
        format.html { redirect_to(@users_package, :notice => 'Users package was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @users_package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users_packages/1
  # DELETE /users_packages/1.xml
  def destroy
    @users_package = UsersPackage.find(params[:id])
    @users_package.destroy

    respond_to do |format|
      format.html { redirect_to(users_packages_url) }
      format.xml  { head :ok }
    end
  end
end
