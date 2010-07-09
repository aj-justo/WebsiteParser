require 'csv.rb'
require 'retriever.rb'

# extiende retriever para www.osculati.com
class Osculati < Retriever 


  private
  def getElementData(elements) 
    if elements.search(('tr')) then
      getProductsTableData(elements).each{|row|
          @dataArray.push row
        }        
    else
#     @dataArray.push getSharedData(elements)
    end
  end
  
  
  
  private
  def getSharedData(elements)
    if elements.to_s.include?('titoloSerie') then
      productsSharedKeys.push 'nombre'
      productsSharedData.push(elements.inner_text)
    else
      if elements.to_s.include?('descrizioneSerie') then
        productsSharedKeys.push 'descripcion'
        productsSharedData.push(elements.inner_text)
      end
    end
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
          found.push getKeys(ths.slice(1,ths.length))
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
  
end




