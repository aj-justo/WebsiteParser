require 'url.rb'
require 'osculati.rb'
require 'csvOutput.rb'



url = Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=19314')
# url = Url.new('http://www.osculati.com/cat/Scheda.aspx?id=2332')

retriever = Osculati.new( CsvOutput.new('/Users/angeljusto/Desktop/osculati'))
retriever.addLanguage('ctl00$lbFR')
retriever.addLanguage('ctl00$lbEN')
retriever.addLanguage('ctl00$lbIT')

# parseamos primero la tabla de productos individuales para poder añadir luego los compartidos por todos
retriever.addElements('table.tabdati',1)
retriever.addElements('p.titoloSerie',1)
retriever.addElements('p.descrizioneSerie',1)

retriever.addFollow('.sottogruppo a') # categorias
retriever.addFollow('table.risultati td a') # subcategorias


retriever.parsePage(url)
puts retriever.getParsedPages.inspect


