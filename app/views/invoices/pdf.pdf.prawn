pdf.font "Helvetica"

pdf.text "Company: #{@invoice.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Invoice: #{@invoice.identifier}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@invoice.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@invoice.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: $#{money(@invoice.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: $#{money(@invoice.total)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Customer information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@invoice.customer.name}", :size => 13, :spacing => 4

if @invoice.customer.email and @invoice.customer.email != ""
  pdf.text "Email: #{@invoice.customer.email}", :size => 13, :spacing => 4
end

if @invoice.customer.account and @invoice.customer.account != ""
  pdf.text "Account: #{@invoice.customer.account}", :size => 13, :spacing => 4
end

if @invoice.customer.phone1 and @invoice.customer.phone1 != ""
  pdf.text "Phone 1: #{@invoice.customer.phone1}", :size => 13, :spacing => 4
end

if @invoice.customer.phone2 and @invoice.customer.phone2 != ""
  pdf.text "Phone 2: #{@invoice.customer.phone2}", :size => 13, :spacing => 4
end

if @invoice.customer.address1 and @invoice.customer.address1 != ""
  pdf.text "Address 1: #{@invoice.customer.address1}", :size => 13, :spacing => 4
end

if @invoice.customer.address2 and @invoice.customer.address2 != ""
  pdf.text "Address 2: #{@invoice.customer.address2}", :size => 13, :spacing => 4
end

if @invoice.customer.city and @invoice.customer.city != ""
  pdf.text "City: #{@invoice.customer.city}", :size => 13, :spacing => 4
end

if @invoice.customer.state and @invoice.customer.state != ""
  pdf.text "State: #{@invoice.customer.state}", :size => 13, :spacing => 4
end

if @invoice.customer.zip and @invoice.customer.zip != ""
  pdf.text "ZIP: #{@invoice.customer.zip}", :size => 13, :spacing => 4
end

if @invoice.customer.country and @invoice.customer.country != ""
  pdf.text "Country: #{@invoice.customer.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @invoice.get_products()
  pdf.text "#{product.full_name} - Price: $#{money(product.curr_price)} - Quantity: #{product.curr_quantity} - Discount: #{money(product.curr_discount)} - Total: $#{money(product.curr_total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: $#{money(@invoice.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: $#{money(@invoice.tax)}", :size => 13, :spacing => 4
pdf.text "Total: $#{money(@invoice.total)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@invoice.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]