require 'url.rb'
require 'retrieve.rb'
require 'nokogiri'

#products = ['01.740.08','01.740.09','01.740.10']
osculati = Url.new('http://www.osculati.com/cat/Scheda.aspx?id=')
#osculati.setCategoryUrlBase('cat/Scheda.aspx?id=')

osculati.setCategory('246')

retriever = Retriever.new()
retriever.getElements('nombre', 'p.titoloSerie strong')
retriever.getElements('descripcion', 'p.descrizioneSerie')
retriever.getElements('caracteristicas', 'table.tabdati tr')

print retriever.parsePage(osculati.getProductUrl())

#products.each { |p|
#    osculati.getProductUrl()
#    print "\r\n"
#}

# cookie osculati
# IDLang
# fr-FR
# en-US