require 'url.rb'
require 'osculati.rb'
require 'csvOutput.rb'



# url = Url.new('http://www.osculati.com/cat/Scheda.aspx?id=')
url = Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=19314')
# setBaseUrl(http://www.osculati.com/cat/)
# url.setCategory('246')

retriever = Osculati.new( CsvOutput.new('/Users/angeljusto/Desktop/osculati'))
retriever.addLanguage('ctl00$lbFR')
# retriever.addLanguage('ctl00$lbEN')
# retriever.addLanguage('ctl00$lbIT')

# parseamos primero la tabla de productos individuales para poder añadir luego los compartidos por todos
retriever.addElements('table.tabdati')
retriever.addElements('p.titoloSerie')
retriever.addElements('p.descrizioneSerie')

retriever.addFollow('table.risultati td a')

retriever.parsePage(url)
puts retriever.getParsedPages.inspect


