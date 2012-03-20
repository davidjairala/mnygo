include UsersHelper

class SessionsController < ApplicationController
  before_filter :checkAdmin
  
  # GET /sessions
  # GET /sessions.xml
  def index
    @pagetitle = "Sessions"
    
    @sessions = Session.paginate :page => params[:page], :order => 'id DESC'
  end

  # GET /sessions/1
  # GET /sessions/1.xml
  def show
    @pagetitle = "View Session"
    @session = Session.find(params[:id])
  end

  # GET /sessions/new
  # GET /sessions/new.xml
  def new
    @pagetitle = "New Session"
    @session = Session.new
  end

  # GET /sessions/1/edit
  def edit
    @pagetitle = "Edit Session"
    @session = Session.find(params[:id])
  end

  # POST /sessions
  # POST /sessions.xml
  def create
    @pagetitle = "New Session"
    @session = Session.new(params[:session])

    respond_to do |format|
      if @session.save
        format.html { redirect_to(@session, :notice => 'Session was successfully created.') }
        format.xml  { render :xml => @session, :status => :created, :location => @session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sessions/1
  # PUT /sessions/1.xml
  def update
    @pagetitle = "Edit Session"
    @session = Session.find(params[:id])

    respond_to do |format|
      if @session.update_attributes(params[:session])
        format.html { redirect_to(@session, :notice => 'Session was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.xml
  def destroy
    @session = Session.find(params[:id])
    @session.destroy

    respond_to do |format|
      format.html { redirect_to(sessions_url) }
      format.xml  { head :ok }
    end
  end
end
