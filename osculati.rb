require 'csv.rb'
require 'retriever.rb'

# extiende retriever para www.osculati.com
class Osculati < Retriever 
  
  private
  def setVars
    @setVars = true
    @productData = {}
    @productsKeys = []
  end


  private
  def getData(elements) 
    if @setVars.nil? then setVars end
      
    if elements.search(('tr')) then
      getProductsTableData(elements)
    else
      getSharedData(elements)
    end
  end
  
  
  
  private
  def getSharedData(elements)
    if elements.to_s.include?('titoloSerie') then
      @productsKeys.push 'nombre'
      @product.push(elements.inner_text)
    else if elements.to_s.include?('descrizioneSerie') then
      @productsKeys.push 'descripcion'
      @product.push(elements.inner_text)
    end
    if @productsKeys.length == getOutput.getRowLength then outputData(@productskeys) end
  end
  
  
  private
  def getProductsTableData(elements)
    tds = elements.search('td')
    
    if tds.length==0 then # es fila cabecera (th)
      ths = elements.search('th')
      unless ths.length==0 then 
        getKeys(ths.slice(1,ths.length)) 
      end
      
    else # es fila datos (td)
      getValues(tds.slice(1, tds.length))
    end
  end
  
  
  private
  def getKeys(tr)
    i=0
    tr.each{|th|
      @productsKeys[i] = th.inner_text
      i=i+1
    }
    if @productsKeys.length == getOutput.getRowLength then outputData(@productskeys) end
  end
  
  private
  def getValues(tr)
    tr.each{|td|
        @product.push(td.inner_text)
    }
    outputData(@product)
  end
  
end




