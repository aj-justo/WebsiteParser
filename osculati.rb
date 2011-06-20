require 'csv.rb'
require 'retriever.rb'

# extiende retriever para www.osculati.com
class Osculati < Retriever  
  
  attr_accessor :string_a_buscar
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
    unless @keysArray.include?('SUBSUBCAT_'<<@currentLanguage)
      @keysArray.push 'SUBSUBCAT_'<<@currentLanguage
    end
    unless @keysArray.include?('NOMBRE_'<<@currentLanguage)
      @keysArray.push 'NOMBRE_'<<@currentLanguage
    end
    unless @keysArray.include?('DESCRIPCION_'<<@currentLanguage)
      @keysArray.push 'DESCRIPCION_'<<@currentLanguage
    end    
  end
  
  
  
  # CATEGORIES
  
  private
  def getCategory
    cat = ''   
    @page.search('#ctl00_ContentPlaceHolder1_hypMacroGruppo').each{|l|
      cat = l.inner_text
    }
    cat
  end  
  
  private
  def getCategoryName(category=nil)
    if category.nil?
      category=getCategory
    end
    name = category.match(/([a-z]+)/i)
    name = $1
  end
  
  
  # general para las de abajo
  private
  def getCatId(cat=nil)
    if cat.nil?
     cat = getCategory
    end
    id = cat.match(/([0-9]+)/)
    id = $1
  end
  
  
  # SUB–CATEGORY
  private
  def getSubCategory
    subcat = ''
    @page.search('#ctl00_ContentPlaceHolder1_hypGruppo').each{|l|    
      subcat = l.inner_text.match(/([0-9]+)/)
      subcat = $1
      subcat<<' - '<<l.inner_text      
    }
    subcat
  end
  
  private
  def getSubCategoryId
    subcat = getSubCategory
    getCatId(subcat)
  end
  
  private
  def getSubCategoryName(subcategory=nil)
    if subcategory.nil?
      subcat=getSubCategory
    end
    name = subcat.match(/([a-z]+)/i)
    name = $1
  end
    


  # SUB-SUB-CATEGORY
  private
  def getSubSubCategory
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
   def getSubSubCategoryName(subcategory=nil)
     if subcategory.nil?
       subcat=getSubSubCategory
     end
     name = subcat.match(/([a-z]+)/i)
     name = $1
   end
   
   private
   def getSubSubCategoryId(category=nil)
     if category.nil?
       category = getSubSubCategory
     end
     id = category.match(/([0-9]+)/)
     id = $1
   end
   
   # esta es para cojer imagenes sueltas
   # para funcionamiento normal comentar y descomentar abajo
   # private
   # def getElementData(element)
# 
     # @page.search('.tabdati').each do |e|
        # if e.to_s.include? @string_a_buscar
          # puts 'modelo encontrado, guardado de imagen'
          # super
        # else 
          # return nil
        # end
      # end
    # end
    
  private
  def getElementData(elements) 
    # array de cabecera para csv
    writeKeys
    # keys de la tabla de caracteristicas del producto, que hay que poner por cada idioma
    # añadiendo a las descripciones, una por linea (abajo)
    descripcionKeys = getTableKeys(elements)

    trs = elements.search('tr')
    if trs.length>1 then
      # puts 'elementos en getelementdata:'
      # puts elements.to_s

      # cada fila es un producto, a pasar en una fila también a csv      
      trs.each{|tr|      
        producto = [] 
        descripcionValues = [] 
        descripcion = []
        
        tds = tr.search('td')
        unless tds.length==0
          
          # una vez por url/producto, no se repiten por language
          id= getId(tr)
          # if @idsEnPagina.nil? then @idsEnPagina = [] end
          # @idsEnPagina.push id
          producto.push id
          producto.push getSubCategoryId
          producto.push getSubSubCategoryId

          nombre = ' '
          producto.push nombre # nombre, en blanco, se recoje posteriormente en elementos shared
          # pasamos de los keys (th)
          # puts 'producto en linea 170'
          # puts producto.inspect   
          # aqui nos da el error de ruby segmentation fault:
          # ./osculati.rb:164: [BUG] Segmentation fault
          # tratamos de evitarlo con el for in
          for i in 2..tds.length do              
              if !tds[i].nil? then
                descripcionValues.push tds[i].inner_text
                # puts 'tds[i]'
                # puts tds[i].inspect
              else
                descripcionValues.push ' '
              end
          end
          # puts 'desctipcionValues:'
          # puts descripcionValues.inspect
          # tds.slice(2,tds.length).each{|td| # no cojemos el 0 (carrito) ni el 1 (id)
          #               if td.to_s.length>0
          #                 descripcionValues.push td.inner_text
          #               end
          #             }
          descripcionValues.reverse!

          descripcionKeys.each{|k|
            linea = ''
            linea <<k<<': '
            unless descripcionValues[-1].nil?           
              linea <<descripcionValues.pop
            end
            descripcion.push linea
          }    

          descripcion = descripcion.join("\n")
          producto.push descripcion

          # producto ya hecho, solo añadimos descripcion a la fila correspondiente (nombre abajo en shared)
          if @dataArray[id].nil?
             @dataArray[id] = producto
          end
          # puts 'en keysArray:'
          # puts @keysArray.inspect
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
      # subsubcat
      subsubcat = getSubSubCategoryName
      index = @keysArray.index('SUBSUBCAT_'<<@currentLanguage)
      @dataArray.each_pair{|id,row|
        row[index] = subsubcat
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
  def getTableKeys(elements)
    ths = elements.search('th')
    # puts 'ths en getElements:'
    # puts ths.inspect
    if ths.length>0
      keys = []
      ths.slice(2,ths.length).each{|th|
        if th.inner_text.length>0
          keys.push th.inner_text
        else
          keys.push th.inner_html
        end
      }
      # puts 'keys en getelementdata:'
      # puts keys.inspect      
      keys
    end
  end
  

  
  private
  def getId(tr)
    tds = tr.search('td')
    id = tds[1].inner_text
  end
 
  
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
    # form.__EVENTVALIDATION = form.__EVENTVALIDATION
#      form.securityToken = form.securityToken
#    form.add_field!('submit', '1')
    # debugger
     @agent.submit(form)
  end
  
  # sobreescribimos metodo para adaptarlo a buscar imagenes sueltas
  # saltando a siguiente url si encuentra elementos
  private
  def parseElements
    if @page.nil? then raise 'primero hay que parsear la pagina' end
    if @elements.nil? then raise 'primero hay que definir elementos a parsear con getElements' end
    @elements.each{|element|
      # elment[0] contiene nombre (css path) de elemento
      found = @page.search(element[0])     
      if found.length>0
        # element es un array que contiene element css path en [0] y numero de elems en [1]
        if element[1]>1
          # buscamos el mismo elemento i num de veces
          for i in 1..element[1] do
            unless getElementData(found[0]).nil? then break end
          end
        else
          getElementData(found[0])       
        end
      end
    } 
  end
  
end




