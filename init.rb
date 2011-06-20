require 'url.rb'
require 'osculati.rb'
require 'csvOutput.rb'



url = Url.new('http://www.ajweb.eu')

retriever = Osculati.new( CsvOutput.new('/path/to/csvfile.csv')) # needs to be created

# as get or post parameters
retriever.addLanguage('es')
retriever.addLanguage('en')

# elements to be retrieved, identified by css hooks
retriever.addElements('table.tabdati',1)

retriever.addFollow('nav#master ul li a') 

# urls that we already know we don't need to follow
retriever.urlsWithNoElements = ['http://ajweb.eu/contact']

retriever.logOutput = CsvOutput.new('/path/to/log/csvfile.csv')
retriever.previousUrlLog('path/to/log/file.csv')
retriever.directOutputLogging = true

retriever.parsePage(url)