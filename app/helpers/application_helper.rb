module ApplicationHelper
  def getAppName()
    return 'mnygo'
  end
  
  def getAppJustUrl()
    return 'mnygo.dev'
  end
  
  def getAppUrl()
    return 'http://' + getAppJustUrl() + '/'
  end
  
  def getAppEmail()
    return 'info@mnygo.com'
  end
  
  def getAppVersion()
    return 1
  end
  
  def linebreaks(str)
    str.gsub("\n", "<br />")
  end
  
  def numeric?
    self.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  
  # Formats text for linebreaks and urls as links
  # Mejor usar format()
  def format_text(str)
    str = linebreaks(str)
    str = auto_link(str)
  end
  
  # Horizontal ruler
  def hr()
    return '<div class="hr"><!-- i --></div>'.html_safe
  end
  
  # Break
  def br()
    return '<div class="break"><!-- i --></div>'.html_safe
  end
  
  # Number to currency format
  def money(number)
    return number_to_currency(number, :format => "%n")
  end
  
  # Returns green or red depending on the number (positive or negative)
  def numColor(number)
    if(number > 0)
      return 'green'
    elsif(number < 0)
      return 'red'
    else
      return ''
    end
  end
  
  # Remove html tags
  def strip_tags(str)
    str.gsub!(/<\/?[^>]*>/, "")
    str.gsub!('&raquo;', '')
    str.gsub!('&nbsp;', ' ')
    
    return str
  end
  
  # Remove everything in parenthesis
  def strip_parenthesis(str)
    str = str.gsub(/\(([a-z][0-9]*)*\)/, '')
    
    return str
  end
  
  # Date format
  def date_format(date)
    date = date.strftime('%a, %d %b %Y %H:%M')
    
    return date
  end
  
  # Gets most important words from a text
  def get_words(str)
    stopwords = stopwords()
    
    str = str.downcase
    str = strip_parenthesis(str)
    str.strip!
    str.gsub!("'", ' ')
    str.gsub!('"', ' ')
    str.gsub!('.', ' ')
    str.gsub!(',', ' ')
    str.gsub!(':', ' ')
    str.gsub!('/', ' ')
    str.gsub!('!', ' ')
    str.gsub!('?', ' ')
    str.gsub!(';', ' ')
    str.gsub!('<', ' ')
    str.gsub!('>', ' ')
    str.gsub!('-', ' ')
    str.gsub!('$', ' ')
    str.gsub!(/( )+/, ' ')
    str_arr = str.split(' ')
    out_arr = []
    
    for word in str_arr
      if(word.length > 3 and out_arr.index(word) == nil and stopwords.index(word) == nil)
        out_arr << word
      end
    end
    
    out = out_arr.join(' ')
    
    return out
  end
  
  # Stopwords
  def stopwords()
    return ['a', 'has', 'such', 'accordance', 'have', 'suitable', 'according', 'having', 'than', 'all', 'herein', 'that', 'also', 'however', 'the', 'an', 'if', 'their', 'and', 'in', 'then', 'another', 'into', 'there', 'are', 'invention', 'thereby', 'as', 'is', 'therefore', 'at', 'it', 'thereof', 'be', 'its', 'thereto', 'because', 'means', 'these', 'been', 'not', 'they', 'being', 'now', 'this', 'by', 'of', 'those', 'claim', 'on', 'thus', 'comprises', 'onto', 'to', 'corresponding', 'or', 'use', 'could', 'other', 'various', 'described', 'particularly', 'was', 'desired', 'preferably', 'were', 'do', 'preferred', 'what', 'does', 'present', 'when', 'each', 'provide', 'where', 'embodiment', 'provided', 'whereby', 'fig', 'provides', 'wherein', 'figs', 'relatively', 'which', 'for', 'respectively', 'while', 'from', 'said', 'who', 'further', 'should', 'will', 'generally', 'since', 'with', 'had', 'some', 'would']
  end
  
  # Regresa la extension de un archivo
  def getFileExt(file_name)
  	ext = file_name.split('.')
  	if(ext.length > 1)
  		f_ext = ext[ext.length - 1]
		
  		if(f_ext)
  			return f_ext
  		end
  	end
  end
  
  # Genera un GUID
  def generate_guid
    require 'digest/md5'
    
    hash = Digest::MD5.hexdigest(Time.now.to_s)
    hash = hash[0..5].upcase
    return hash
  end
  
  # Regresa extensiones para imagenes
  def imgTypes()
    return ["gif", "jpg", "jpeg", "png"]
  end
  
  # Revisa extension de un archivo
  def checkFileExtension(file, extensions)
    name = file.original_filename
    ext = getFileExt(name)
    
    if(extensions.include?(ext.downcase))
      return true
    end
  end
  
  # Sube un archivo
  def uploadFile(file, dir)
  	require 'digest/md5'
	
  	name = file.original_filename
	
  	new_name = Digest::MD5.hexdigest(Time.now.to_s)
  	ext = getFileExt(name)
	
  	new_name = "#{new_name}.#{ext}"
	
  	path = File.join(dir, new_name)
	
  	File.open(path, "wb") { |f| 
  		f.write(file.read)
  	}
	
  	# Quitamos parte de public para el path
  	path_arr = path.split('/')
  	path_arr.delete_at(0)
  	path = '/' + path_arr.join('/')
	
    return path
  end
  
  # Resize a una imagen
  def resizeImage(file, size)
    img_orig = Magick::Image.read("public/#{file}").first
    
    width = img_orig.columns
    height = img_orig.rows
    
    if(width > size || height > size)
      if(width > height)
        height = size * height / width
        width = size
      else
        width = size * height / width
        height = size
      end
    
      img = img_orig.resize_to_fit(width, height)
    
      img.write("public/#{file}")
    end
  end
  
  # Borra un archivo
  def deleteFile(file)
	  FileUtils.rm file
  end
  
  # Limpia tags no valido de un string
  def clean_html(str)
	  str = str.gsub(/<script(.*)>(.*)<\/script>/i, "")
	  str = str.gsub(/<frame(.*)>(.*)<\/frame>/i, "")
	  str = str.gsub(/<iframe(.*)>(.*)<\/iframe>/i, "")
	
	  return str
  end
  
  # Procesa un texto con markdown y otros asuntos
  def mark_text(str)
	  str = clean_html(str)
	  
	  return str
  end
  
  # Pasa caracteres a html
  def html_encode
    require 'htmlentities'
    
    coder = HTMLEntities.new
    
    ret = coder.encode(self, :named)
    
    return ret
  end
  
  # Pasa html a caracteres
  def html_decode
    require 'htmlentities'
    
    coder = HTMLEntities.new
    
    ret = coder.decode(self)
    
    return ret
  end
  
  # Pasa un string a slug
  def to_slug
    #strip the string
    ret = self.strip
    
    #blow away apostrophes
    ret.gsub! /['`]/,""
    
    # Reemplazamos tildes por normales
    ret = ret.html_encode
    ret.downcase!
    ret.gsub! /&amp;/i, '_'
    ret.gsub! /&([a-z])acute;/i, '\1'
    ret.gsub! /&([a-z])tilde;/i, '\1'
    ret = ret.html_decode

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, "_"
    ret.gsub! /\s*&\s*/, "_"

    #replace all non alphanumeric, underscore or periods with underscore
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  
    
    #convert double underscores to single
    ret.gsub! /_+/,"_"
    
    #strip off leading/trailing underscore
    ret.gsub! /\A[_\.]+|[_\.]+\z/,""
    
    return ret
  end
  
  # Crea un directorio si no existe
  def makedir(dir)
    FileUtils.mkdir_p dir
  end
  
  # Copia un archivo
  def copy_file(src, dest)
    FileUtils.cp src, dest
  end
  
  # Cambia nombre de un archivo de imagen para sacar otro tamano
  def img_name_size(file, size)
    return file.sub("_300", "_#{size}")
  end
  
  # Quita comas de un parametro
  def quita_comas
    s = self.to_s
    
    s.gsub!(/,/, "")
    
    s = s.to_f
    
    return s
  end
  
  # Months array
  def monthsArr
    m = [
      ["January", "1"],
      ["February", "2"],
      ["March", "3"],
      ["April", "4"],
      ["May", "5"],
      ["June", "6"],
      ["July", "7"],
      ["August", "8"],
      ["September", "9"],
      ["October", "10"],
      ["November", "11"],
      ["December", "12"]
    ]
    
    return m
  end
  
  # Return last day of a month
  def last_day_of_month(year, month)
    last_day_of_the_month = (Date.parse(year.to_s + "-" + (month.to_i + 1).to_s + "-01") - 1).mday().to_s rescue "31"
    
    return last_day_of_the_month.to_i
  end
  
  # Regresa un arreglo con meses
  def getArrMeses
    m = Array.new
    
    m[1] = "Enero"
    m[2] = "Febrero"
    m[3] = "Marzo"
    m[4] = "Abril"
    m[5] = "Mayo"
    m[6] = "Junio"
    m[7] = "Julio"
    m[8] = "Agosto"
    m[9] = "Septiembre"
    m[10] = "Octubre"
    m[11] = "Noviembre"
    m[12] = "Diciembre"
    
    return m
  end
  
  # Regresa meses cortos
  def getArrMesesShort
    meses = getArrMeses()
    
    meses.each_with_index do |mes, index|
      meses[index] = mes.to_s[0..2]
    end
    
    return meses
  end
  
  # Formatea una fecha
  def doDate(date, style = 1)
    dia = date.strftime("%a")
    mes = date.strftime("%b")
    anio = date.strftime("%Y")
    hora = date.strftime("%H:%I")
    
    if(style == 1)
      fecha = dia + " " + date.strftime("%e") + ", " + mes + " " + anio + " " + hora
    elsif(style == 2)
      fecha = date.strftime("%e") + "/" + mes + "/" + anio + " " + hora
    elsif(style == 3)
      fecha = dia + " " + date.strftime("%e") + ", " + mes + " " + anio
    elsif(style == 4)
      fecha = mes + " " + anio
    elsif(style == 5)
      fecha = dia + " " + date.strftime("%e")
    end
    
    return fecha
  end
  
  # Agarra el nombre de un mes
  def getMesName(mes)
    meses = getArrMeses
    m = meses[mes]
  end
  
  # Arregla idioma de links de paginacion
  def idiomaPag(str)
    if(str and str != "")
      str.gsub! /previous/i, "Anterior"
      str.gsub! /next/i, "Siguiente"
    end
    
    return str
  end
  
  # Format text for display.                                                                    
  def format_text(text)
    sanitize(linebreaks(auto_link(text)))
  end

  # Process text with Markdown.                                                                 
  def markdown(text)
    BlueCloth::new(text).to_html
  end
  
  # Countries select
  def countries_array
    return ["", "United States", "United Kingdom", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, The Democratic Republic of The", "Cook Islands", "Costa Rica", "Cote D\'ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-bissau", "Guyana", "Haiti", "Heard Island and Mcdonald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran, Islamic Republic of", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People\'s Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao People\'s Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Palestinian Territory, Occupied", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Helena", "Saint Kitts and Nevis", "Saint Lucia", "Saint Pierre and Miquelon", "Saint Vincent and The Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia and Montenegro", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and The South Sandwich Islands", "Spain", "Sri Lanka", "Sudan", "Suriname", "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Timor-leste", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Viet Nam", "Virgin Islands, British", "Virgin Islands, U.S.", "Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]
  end
  
  # Converts a string into a word array without extra spaces, etc
  def string_to_arr(str)
    arr = str.split(" ")
    arr_f = []
    
    for a in arr
      if a != ""
        arr_f.push(a.strip)
      end
    end
    
    return arr_f
  end
  
  # Converts a string to a sql search string
  def str_sql_search(str, fields)
    str.gsub!("'", '')
    str.gsub!('"', '')
    str.gsub!("\\", '')
    str.gsub!("%", '')
    
    arr = string_to_arr(str)
    rows = []
    cells = []
    
    for field in fields
      cells = []
      
      for a in arr
        cells.push("(#{field} LIKE \"%#{a}%\")")
      end
      
      rows.push("(" + cells.join(" AND ") + ")")
    end
    
    return rows.join(" OR ")
  end
  
  # Remove comas from a string
  def format_csv()
    require 'iconv'
    
    str = self.to_s
    
    str.gsub!(",", "")
    str.gsub!(10.chr, " - ")
    str.gsub!(13.chr, "")
    str = Iconv.conv('ISO-8859-1', 'utf-8', str)
    
    return str
  end
  
  # Handles header info for csv
  def render_csv(filename = nil)
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain; charset=iso-8859-1;"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/csv; charset=iso-8859-1;'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    render :layout => false
  end
end