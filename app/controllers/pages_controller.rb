include UsersHelper

class PagesController < ApplicationController
  before_filter :checkAdmin, :except => [:dashboard, :quick_upload, :err_not_found, :name_clean, :frontpage]
  # Dashboard
  def dashboard
    @pagetitle = "Dashboard"
    
    if(not isLogged())
      flash[:error] = 'You must sign up and log in to view your dashboard.'
      redirect_to '/login?next=dashboard'
    else
      @pagetitle = 'Dashboard'
      @user_package = UsersPackage.find(:first, :conditions => {:user_id => getUserId()})
      @companies = getUser().get_companies()
    
      if(not @user_package)
        flash[:error] = 'Please first pick a pricing plan.'
        redirect_to '/pricing'
      else
        @next_package = Package.find(:first, :conditions => ["price > ?", @user_package.package.price])
      end
    end
  end
  
  # Sube imagen rapido (ajax)
  def quick_upload
	  if(params[:image] and params[:image][:imagen])
	    # Checamos si es un archivo permitido
	    ext = getFileExt(params[:image][:imagen].original_filename)
	    ext = ext.downcase()
	
	    if(ext == 'png' || ext == 'gif' || ext == 'jpg' || ext == 'jpeg')
	      upload_dir = "public/uploads/images/#{getUserId()}"
	      # Creamos directorio si no existe
	      makedir(upload_dir)
	      
		    # Agarramos archivo a subir
		    new_name = uploadFile(params[:image][:imagen], upload_dir)
		  
		    # Hacemos resize
		    resizeImage(new_name, 600)
		  
		    @image = Image.new(:user_id => getUserId(), :url => new_name)
	    end
	  end
	
	  if(!params[:image] or !params[:image][:imagen])
		  render :partial => "quick_upload_error"
	  elsif(@image)
		  if @image.save
			  render :partial => "quick_upload_ok"
		  else
			  render :partial => "quick_upload_error"
		  end
	  else
		  render :partial => "quick_upload_error"
	  end
  end
  
  # 404
  def err_not_found
    @pagetitle = "404 - Not found"
    flash[:error] = "We couldn't find what you were looking for."
  end
  
  # Pasa vista de una pagina de acuerdo a su nombre limpio
  def name_clean
    @page = Page.find(:first, :conditions => {:title_clean => params[:page_name]})
    @pagetitle = "#{@page.title}"
    
    if(not @page)
      redirect_to '/err_not_found'
    else
      @pagetitle = @page[:title]
    end
  end
  
  # Frontpage
  def frontpage
  end
  
  # GET /pages
  # GET /pages.xml
  def index
    @pagetitle = "Pages"
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])
    @pagetitle = "Pages - #{@page.title}"
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @pagetitle = "New page"
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    @pagetitle = "Edit page"
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @pagetitle = "New page"
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to(@page, :notice => 'Page was successfully created.') }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @pagetitle = "Edit page"
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(@page, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
end
