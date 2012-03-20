module CompaniesHelper
  def set_company(company)
    session[:company] = company
  end
  
  def get_session_company()
    if(isLogged() and session[:company])
      return session[:company]
    end
  end
  
  def checkCompanies()
    if(isLogged())
      company = Company.find(:first, :conditions => {:user_id => getUserId()})
      
      if not company
        flash[:error] = "Please create a company first."
        redirect_to "/companies/new"
      end
    end
  end
end