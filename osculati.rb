require 'csv.rb'
require 'retriever.rb'

# extiende retriever para www.osculati.com
class Osculati < Retriever 

  # 
  # private
  # def setDataGotForPage(url)
  #   if @dataGot.nil? then @dataGot = [] end
  #   @dataGot.push url
  # end
  # 
  # private
  # def resetDataGot
  #   @dataGot = []
  # end
  
  private
  def addFoundKeys(keys)
    if @foundKeys.nil? then @foundKeys=[] end
    if keys.is_a(String) and !inFoundKeys?(keys)
      @foundKeys.push key
    end
    if keys.is_a(Array)
      keys.each{|key|
        unless inFoundKeys?(key)
          @foundKeys.push key
        end
      }
  end
  
  private
  def inFoundKeys?(key)
    @foundKeys.include?(key)
  end
  
  private
  def writeKeys
    if @keys.nil?
      @keys = ['ID', 'CAT', 'SUBCAT']
      @languages.each{|lang|
        @keys.push 'NOMBRE_'<<lang
        @keys.push 'DESCRIPCION_'<<lang
      }
      @output.write(@keys)
    end
  end
  

  private
  def getElementData(elements) 
    writeKeys
#    estos son los productos individuales, en una tabla
#   solo queremos cojer estos datos una vez para cada pagina
    if elements.search('tr').length>1 then

      getProductsTableData(elements).each{|row|
          @dataArray.push row
      }       
#    estos son los datos compartidos por todos los productos (nombre, descripcion)
#   queremos cojerlos para todos los idiomas (siempre)
    else
#      añadimos valores compartidos a todos los productos
      @dataArray[1,@dataArray.length].each{|row|
        row.push getSharedData(elements)
      }
    end
  end
  
  
  
  private
  def getSharedData(elements)   
      elements.inner_text
  end
  
  private
  def getSharedKeys(elements)
    if elements.to_s.include?('titoloSerie') then
      t = 'nombre'
    end
    if elements.to_s.include?('descrizioneSerie') then
      t = 'descripcion'
    end
    t
  end
  
#  datos individuales de cada producto guardados en una tabla
#  distinguimos entre la primera tr de cabeceras y el resto datos de cada producto
  private
  def getProductsTableData(elements)
    found = []
    trs = elements.search('tr')
    trs.each{|tr|
      if tr.search('td').length>1 then
        tds = tr.search('td')
        found.push getValues(tds.slice(1, tds.length))
      else
        if tr.search('th').length>1 then
          ths = tr.search('th')
          # found.push getKeys(ths.slice(1,ths.length))
          # los keys los grabamos todos juntos al final
          # addFoundKeys(ths.slice(1,ths.length))
        end
      end
    }
    found
  end
  
  
  private
  def getKeys(tr)
    keys=[]
    i=0
    tr.each{|th|
      keys[i] = th.inner_text
      i=i+1
    }
    keys
  end
  
  private
  def getValues(tr)
    values=[]
    tr.each{|td|
        values.push(td.inner_text)
    }    
    values
  end
  
  private
  def setLanguage(language)
    page = @agent.get @url.url
    puts 'url en setLanguage:'
    puts @url.url
#    print page.inspect
    form = page.forms.first
    form.__EVENTTARGET = language
    form.__EVENTARGUMENT = ''
    form.__VIEWSTATE = form.__VIEWSTATE
    form.__EVENTVALIDATION = form.__EVENTVALIDATION
#      form.securityToken = form.securityToken
#    form.add_field!('submit', '1')
    # debugger
     @agent.submit(form)
  end
  
end




