include ApplicationHelper
include UsersHelper

class PackagesController < ApplicationController
  before_filter :checkAdmin, :except => [:pricing, :pick_package, :payment]
  
  # Payment
  def payment
    @pagetitle = 'Payment'
    @slug = params[:slug]
    @package = Package.find(:first, :conditions => {:slug => @slug})
    
    if(not @package)
      flash[:error] = "We couldn't find the package you selected, please try again."
      redirect_to('/pricing')
    end
    
    if(@slug == 'free')
      @package.register(getUser())
      flash[:notice] = 'Thank you for signing up with ' + getAppName() + '!'
      redirect_to '/dashboard'
    end
  end
  
  # Pick package
  def pick_package
    @pagetitle = 'Review plan information'
    @slug = params[:slug]
    
    if(isLogged())
      @package = Package.find(:first, :conditions => {:slug => @slug})
      
      if(not @package)
        flash[:error] = "We couldn't find the package you selected, please try again."
        redirect_to('/pricing')
      end
    else
      flash[:error] = "To choose a pricing plan you must first login/sign up.  It's completely free and won't take you more than a minute."
      redirect_to('/login?next=pricing/' + @slug)
    end
  end
  
  # Pricing
  def pricing
    @pagetitle = 'Pricing'
    @packages = Package.find(:all, :order => 'price ASC')
  end
  
  # GET /packages
  # GET /packages.xml
  def index
    @pagetitle = "Packages"
    @packages = Package.all
  end

  # GET /packages/1
  # GET /packages/1.xml
  def show
    @package = Package.find(params[:id])
    @pagetitle = "Packages - #{@package.title}"
  end

  # GET /packages/new
  # GET /packages/new.xml
  def new
    @pagetitle = "New package"
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit
    @package = Package.find(params[:id])
    @pagetitle = "Edit package"
  end

  # POST /packages
  # POST /packages.xml
  def create
    @pagetitle = "New package"
    @package = Package.new(params[:package])
    @package[:slug] = @package[:title].to_slug

    respond_to do |format|
      if @package.save
        format.html { redirect_to(@package, :notice => 'Package was successfully created.') }
        format.xml  { render :xml => @package, :status => :created, :location => @package }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /packages/1
  # PUT /packages/1.xml
  def update
    @pagetitle = "Edit package"
    @package = Package.find(params[:id])
    @package[:slug] = params[:package][:title].to_slug

    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html { redirect_to(@package, :notice => 'Package was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.xml
  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      format.html { redirect_to(packages_url) }
      format.xml  { head :ok }
    end
  end
end
