include UsersHelper

class UsersController < ApplicationController
  before_filter :checkAdmin, :except => [:register, :logout, :err_perms, :login, :show]
  
  # Register
  def register
    require "digest"
    
    @pagetitle = "Register account"
    
    if params[:next]
      @next = params[:next]
    end
    
    if params[:user]
      params[:user][:level] = "user"
      old_password = params[:user][:password]
      @user = User.new(params[:user])
      
      respond_to do |format|
        if @user.save
          # Hash password
          @user.password = Digest::MD5.hexdigest(getSalt() + params[:user][:password])
          @user.save
          
          if(@next)
            redirect = '/login?next=' + @next
          else
            redirect = '/login'
          end
          
          format.html { redirect_to(redirect, :notice => 'You have signed up successfully.  Please log in with the information you provided:') }
        else
          @user.password = old_password
          format.html { render :action => "register" }
        end
      end
    end
    
    @user = User.new
  end
  
  # Logout
  def logout
    doLogout()
    
    flash[:notice] = 'You have logged out succesfully.'
    redirect_to '/'
  end
  
  # Error - Permissions
  def err_perms
    @pagetitle = "Permissions error"
    flash[:error] = "You can't view this."
  end
  
  # Login
  def login
    require "digest"
    
    @pagetitle = "Login"
    
    if params[:next]
      @next = params[:next]
    end
    
    if params[:user]
      @user = User.find(:first, :conditions => ["username = ? AND password = ?", params[:user][:username], Digest::MD5.hexdigest(getSalt() + params[:user][:password])])
      
      if @user
        doLogin(@user)
        
        flash[:notice] = 'You have logged in successfully.'
        
        if params[:next]
          redirect_to '/' + params[:next]
        else
          redirect_to '/dashboard'
        end
      else
        flash[:error] = 'Wrong username or password.'
      end
    end
  end
  
  # GET /users
  # GET /users.xml
  def index
    @pagetitle = "Users"
    
    @users = User.paginate :page => params[:page], :order => 'id DESC'
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @pagetitle = "View user"
    
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @pagetitle = "New user"
    
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @pagetitle = "Edit user"
    
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    require "digest"
    
    @pagetitle = "New user"
    
    # Hash password
    if params[:user][:password]
      params[:user][:password] = Digest::MD5.hexdigest(getSalt() + params[:user][:password])
    end
    
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    require "digest"
    
    @pagetitle = "Edit user"
    
    @user = User.find(params[:id])
    
    # Hash password
    if params[:user][:password] and params[:user][:password] != @user.password
      params[:user][:password] = Digest::MD5.hexdigest(getSalt() + params[:user][:password])
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
