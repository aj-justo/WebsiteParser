require 'url.rb'
require 'osculati.rb'
require 'csvOutput.rb'



url = Url.new('http://www.osculati.com/cat/MainCat.aspx')
# url = Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=13563')

retriever = Osculati.new( CsvOutput.new('/Users/angeljusto/Desktop/OSCULATI/osculati.csv'))
retriever.addLanguage('ctl00$lbFR')
retriever.addLanguage('ctl00$lbEN')
retriever.addLanguage('ctl00$lbIT')

# parseamos primero la tabla de productos individuales para poder añadir luego los compartidos por todos
retriever.addElements('table.tabdati',1)
retriever.addElements('p.titoloSerie',1)
retriever.addElements('p.descrizioneSerie',1)

retriever.addFollow('.sottogruppo a') # categorias
retriever.addFollow('table.risultati td a') # subcategorias

retriever.urlsWithNoElements = ['http://www.osculati.com/cat/MainCat.aspx', '%Serieweb.aspx?%']

retriever.logOutput = CsvOutput.new('/Users/angeljusto/Desktop/OSCULATI/osculati_log.csv')
retriever.previousUrlLog('/Users/angeljusto/Desktop/OSCULATI/Log_ultimo_ok.csv')
retriever.directOutputLogging = true
retriever.parsePage(url)
puts retriever.getParsedPages.inspect


