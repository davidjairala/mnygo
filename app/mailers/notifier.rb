class Notifier < ActionMailer::Base
  default :from => getAppEmail(),
    :return_path => getAppEmail()
  
  def invoice(to, invoice)
    @invoice = invoice
    @to = to
    mail(:to => to)
  end
end
