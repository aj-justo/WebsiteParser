require 'csv.rb'
require 'retriever.rb'
require 'osculati.rb'

# extiende Osculati para cojer las imagenes
# necesitamos override getElementsData
class Osculati_images < Osculati
  
  private
  def getElementData(element)
    super
  end
  
end