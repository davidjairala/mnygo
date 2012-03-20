module CustomersHelper
  def checkCustomers()
    if(params[:company_id])
      customer = Customer.find(:first, :conditions => {:company_id => params[:company_id]})
    
      if(not customer)
        flash[:error] = "Please create a customer first."
        redirect_to "/customers/new/#{params[:company_id]}"
      end
    end
  end
end
