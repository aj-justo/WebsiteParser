require 'csv.rb'
require 'retriever.rb'

# extiende retriever para www.osculati.com
class Osculati < Retriever  
  
  # keys array: [id, cat, subcat, nombre_idioma1, descripcion_idioma1, nombre_idioma2, descripcion_idioma2, ... ]
  private
  def writeKeys     
    if @keysArray.nil? or !@keysArray.include?('ID') # primer idioma
        @keysArray = ['ID', 'CAT', 'SUBCAT']
    end # esto una vez por cada idioma
    
    unless @keysArray.include?('CAT_'<<@currentLanguage)
      @keysArray.push 'CAT_'<<@currentLanguage
    end 
    unless @keysArray.include?('SUBCAT_'<<@currentLanguage)
      @keysArray.push 'SUBCAT_'<<@currentLanguage
    end
    unless @keysArray.include?('NOMBRE_'<<@currentLanguage)
      @keysArray.push 'NOMBRE_'<<@currentLanguage
    end
    unless @keysArray.include?('DESCRIPCION_'<<@currentLanguage)
      @keysArray.push 'DESCRIPCION_'<<@currentLanguage
    end    
  end
  
  
  private
  def getCategory
    cat = ''
    @page.search('#ctl00_ContentPlaceHolder1_hypGruppo').each{|l|
      cat = l.inner_text
    }
    cat
  end
  
  private
  def getCategoryId(category=nil)
    if category.nil?
      category = getCategory
    end
    id = category.match(/([0-9]+)/)
    id = $1
  end
  
  private
  def getCategoryName(category=nil)
    if category.nil?
      category=getCategory
    end
    name = category.match(/([a-z]+)/i)
    name = $1
  end
  
  private
  def getSubCategory
    subcat = ''
    @page.search('#ctl00_ContentPlaceHolder1_hypSottoGruppo').each{|l|
      # puts 'href en getSubcategory:'
      # puts l.attributes['href'].inner_text      
      subcat = l.attributes['href'].inner_text.match(/([0-9]+)$/)
      subcat = $1
      subcat<<' - '<<l.inner_text      
    }
    # puts 'subcategoria id:'
    # puts getCategoryId(subcat)
    subcat
  end
  
  private
  def getSubCategoryId
    subcat = getSubCategory
    getCategoryId(subcat)
  end
  
  private
  def getSubCategoryName(subcategory=nil)
    if subcategory.nil?
      subcat=getSubCategory
    end
    name = subcat.match(/([a-z]+)/i)
    name = $1
  end
  

  private
  def getElementData(elements) 
    # array de cabecera para csv
    writeKeys
    # keys de la tabla de caracteristicas del producto, que hay que poner por cada idioma
    # añadiendo a las descripciones, una por linea (abajo)
    descripcionKeys = getKeys(elements)

    trs = elements.search('tr')
    if trs.length>1 then
      # puts 'elementos en getelementdata:'
      # puts elements.to_s

      # cada fila es un producto, a pasar en una fila también a csv      
      trs.each{|tr|       
        tds = tr.search('td')
        unless tds.length==0
          producto = [] 
          # una vez por url/producto, no se repiten por language
          id= getId(tr)
          # if @idsEnPagina.nil? then @idsEnPagina = [] end
          # @idsEnPagina.push id
          producto.push id
          producto.push getCategoryId
          producto.push getSubCategoryId

          nombre = ' '
          producto.push nombre # nombre, en blanco, se recoje posteriormente en elementos shared
          # pasamos de los keys (th)
          descripcionValues = []    
          tds.slice(2,tds.length).each{|td| # no cojemos el 0 (carrito) ni el 1 (id)
              descripcionValues.push td.inner_text
            }
          descripcionValues.reverse!
          descripcion = []
          descripcionKeys.each{|k|
            k <<': '
            k <<descripcionValues.pop
            descripcion.push k
          }    
          descripcion = descripcion.join("\n")
          producto.push descripcion
          # puts 'producto en getElementData:'
          # puts producto.inspect
          # producto ya hecho, solo añadimos descripcion a la fila correspondiente (nombre abajo en shared)
         if @dataArray[id].nil?
             @dataArray[id] = producto
          else
            col = @keysArray.index('DESCRIPCION_'<<@currentLanguage)
            # puts 'columna en linea 121:'
            # puts col
            # puts 'dataarray[id].length:'
            # puts @dataArray[id].length
            if @dataArray[id][col].nil?
              @dataArray[id][col] = descripcion
            else
              @dataArray[id][col] <<= descripcion
            end
          end
          
        end   
      }

      # getProductsTableData(elements).each{|row|
      #           @dataArray.push row
      #       }       
#    estos son los datos compartidos por todos los productos (cat, subcat, nombre, descripcion)
#   queremos cojerlos para todos los idiomas (siempre)
    else
      
      # cat
      cat = getCategoryName
      index = @keysArray.index('CAT_'<<@currentLanguage)
      @dataArray.each_pair{|id,row|
        row[index] = cat
      }
      
      # subcat
      subcat = getSubCategoryName
      index = @keysArray.index('SUBCAT_'<<@currentLanguage)
      @dataArray.each_pair{|id,row|
        row[index] = subcat
      }
      
      # nombre
      if elements.to_s.include?('titoloSerie')
          index = @keysArray.index('NOMBRE_'<<@currentLanguage)
          @dataArray.each_pair{|id,row|
            row[index] = elements.inner_text
          }        
      end
      # descripcion
      if elements.to_s.include?('descrizioneSerie')
        index = @keysArray.index('DESCRIPCION_'<<@currentLanguage)
        @dataArray.each_pair{|id, row|
          if row[index].nil?
            row[index] = elements.inner_text
          else
            row[index] =row[index]<<elements.inner_text
          end
        }
      end
    end
    # logDoneUrls
  end
  
  private
  def getKeys(elements)
    ths = elements.search('th')
    # puts 'ths en getElements:'
    # puts ths.inspect
    if ths.length>0
      keys = []
      ths.slice(2,ths.length).each{|th|
        keys.push th.inner_text
      }
      # puts 'keys en getelementdata:'
      # puts keys.inspect      
      keys
    end
  end
  
  
  # private
  # def getProductos(tr)
  #   tds = tr.search('td')
  #   if tds.length==0 then return 0 end
  #   row=[]
  #   row.push getId(tr)
  #   row.push getCategory
  #   row.push getSubCategory
  #   nombre = ' '
  #   row.push nombre # nombre, en blanco, se recoje posteriormente en elementos shared
  #   # pasamos de los keys (th)
  #   descripcion = []    
  #   tds.slice(2,tds.length).each{|td| # no cojemos el 0 (carrito) ni el 1 (id)
  #       descripcion.push td.inner_text
  #     }    
  #   row.push descripcion.join("\n")
  #   row
  # end
  
  # private
  # def addSharedToDataArray(index, elements)
  #   puts 'index, pasado a addshared:'
  #   puts index
  #   
  #   @dataArray.slice(1,@dataArray.length).each{|row|
  #       puts 'row en addsharedtodataarray:'
  #       puts row.inspect
  #       row[index]<<= elements.inner_text
  #   }
  # end
  
  private
  def getId(tr)
    tds = tr.search('td')
    id = tds[1].inner_text
  end
  
  # private
  # def getSharedData(elements)   
  #     elements.inner_text
  # end
  
  # private
  #  def getSharedKeys(elements)
  #    if elements.to_s.include?('titoloSerie') then
  #      t = 'nombre'
  #    end
  #    if elements.to_s.include?('descrizioneSerie') then
  #      t = 'descripcion'
  #    end
  #    t
  #  end
  
  
  
  
#  datos individuales de cada producto guardados en una tabla
#  distinguimos entre la primera tr de cabeceras y el resto datos de cada producto
  # private
  # def getProductsTableData(elements)
  #   found = []
  #   trs = elements.search('tr')
  #   trs.each{|tr|
  #     tds = tr.search('td')
  #     if tds.length>1 then
  #       # el primero es icono cesta, el segundo [1] = ID
  #       id = tds[1]
  #       data = getValues(tds.slice(2, tds.length))
  #       # found.push getValues(tds.slice(1, tds.length))
  #     else
  #       if tr.search('th').length>1 then
  #         ths = tr.search('th')
  #         # found.push getKeys(ths.slice(1,ths.length))
  #         # los keys los grabamos todos juntos al final
  #         # addFoundKeys(ths.slice(1,ths.length))
  #       end
  #     end
  #   }
  #   found
  # end
  
  
  # private
  # def getKeys(tr)
  #   keys=[]
  #   i=0
  #   tr.each{|th|
  #     keys[i] = th.inner_text
  #     i=i+1
  #   }
  #   keys
  # end
  # 
  # private
  # def getValues(tr)
  #   values=[]
  #   tr.each{|td|
  #       values.push(td.inner_text)
  #   }    
  #   values
  # end
  
  private
  def setLanguage(language)
    page = @agent.get @url.url
    # puts 'url en setLanguage:'
    # puts @url.url
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




