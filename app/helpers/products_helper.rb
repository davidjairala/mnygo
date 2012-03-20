module ProductsHelper
  def checkProducts()
    if(params[:company_id])
      product = Product.find(:first, :conditions => {:company_id => params[:company_id]})
    
      if(not product)
        flash[:error] = "Please create a product first."
        redirect_to "/products/new/#{params[:company_id]}"
      end
    end
  end
end
