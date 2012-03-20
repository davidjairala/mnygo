include UsersHelper

class CompanyUsersController < ApplicationController
  before_filter :checkLogin
  
  # Autocomplete users
  def ac_users
    @users = User.find(:all, :conditions => ["username LIKE ? OR email LIKE ?", "%" + params[:q] + "%", "%" + params[:q] + "%"])
   
    render :layout => false
  end
  
  # List company users
  def list_users
    @company = Company.find(params[:company_id])
    @pagetitle = "#{@company.name} - Locations"
  
    if(@company.can_view(getUser()))
      @company_users = CompanyUser.find(:all, :conditions => {:company_id => @company.id})
    else
      errPerms()
    end
  end
  
  # GET /company_users
  # GET /company_users.xml
  def index
    @company_users = CompanyUser.all
  end

  # GET /company_users/1
  # GET /company_users/1.xml
  def show
    @company_user = CompanyUser.find(params[:id])
  end

  # GET /company_users/new
  # GET /company_users/new.xml
  def new
    @company_user = CompanyUser.new
    @company = Company.find(params[:company_id])
    @company_user[:company_id] = @company[:id]
    
    # Check package limits
    @users_left_i = getUser().users_left
    @users_left = getUser().print_users_left
    @users_left_class = getUser().users_left_class
  end

  # GET /company_users/1/edit
  def edit
    @company_user = CompanyUser.find(params[:id])
  end

  # POST /company_users
  # POST /company_users.xml
  def create
    @company_user = CompanyUser.new(params[:company_user])
    @company = Company.find(params[:company_user][:company_id])
    
    @users_left_i = getUser().users_left
    @users_left = getUser().print_users_left
    @users_left_class = getUser().users_left_class
    
    # Check package limits
    if(@users_left_i <= 0 and @users_left_i > -1000)
      flash[:error] = "You have created the most users you can within your package.  Please select another package to create more users."
      redirect_to("/pricing")
    else
      if(params[:company_user][:user_id] and params[:company_user][:user_id] != "")
        # Check if user already exists for the company
        @alr_user = CompanyUser.find(:first, :conditions => {:company_id => @company.id, :user_id => params[:company_user][:user_id]})

        if(@alr_user)
          err_alr = true
        end
      end

      if(err_alr)
        flash[:error] = "This user is already part of the company"
        redirect_to "/company_users/new/#{@company.id}"
      elsif @company_user.save
        redirect_to(@company_user, :notice => 'Company user was successfully created.')
      else
        render :action => "new"
      end
    end
  end

  # PUT /company_users/1
  # PUT /company_users/1.xml
  def update
    @company_user = CompanyUser.find(params[:id])

    respond_to do |format|
      if @company_user.update_attributes(params[:company_user])
        format.html { redirect_to(@company_user, :notice => 'Company user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /company_users/1
  # DELETE /company_users/1.xml
  def destroy
    @company_user = CompanyUser.find(params[:id])
    company_id = @company_user[:company_id]
    @company = @company_user.company
    
    # Check if we can delete the user
    if(@company_user.user_id != @company.user_id)
      @company_user.destroy
    else
      flash[:error] = "You cannot delete the company creator from the company."
    end
    
    redirect_to("/companies/company_users/" + company_id.to_s)
  end
end
