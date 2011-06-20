require 'csv'
require 'csvOutput.rb'

class ProcessCSV

	attr_accessor :newCSVArray
	attr_reader :csvParsedFile
	
  def initialize(csvFile, separator='|')
    if csvFile.nil? then rise 'No csvFile passed' end
    
    @csvFileName = csvFile
    @csvParsedFile = CSV::Reader.parse(File.open(@csvFileName,'r+b'), separator)
    
#    por defecto rellenamos newCSVArray con contenido actual
     @newCSVArray = []
     @csvParsedFile.each do |row|
     	@newCSVArray.push row 
     end
#     puts @newCSVArray.inspect
    
    @foundValues = []
    
  end
  
  
#   recorrer cada row del csv en busca del valor requerido 
#	el valor a buscar se puede dar: pattern regexp a buscar con el valor en $1; posicion en fila  como un integer
  def search(pattern=nil, position=nil)
  	if pattern.nil?  and position.nil? then rise 'no pattern or position' end
  	if @csvParsedFile.nil? then rise 'no csv file stream' end
  	
	@csvParsedFile.each do |row|
		value = getValue(row, pattern, position)
		unless value.nil?	
	  		@foundValues.push value
	  		row.push value 
	  		puts value
	  	end	  	
	  	@newCSVArray.push row
    end
  end
  
#   cojemos valor, bien por posicion, bien por pattern, bien por ambos
  def getValue(row, pattern=nil, position=nil)
  	if pattern.nil? and position.nil? then return row end
  	
  	unless position.nil? then value = row[position] else value = row end
  	unless pattern.nil? or !pattern.is_a? Regexp
  		if value.is_a? Array
  			value.each do |val|
  				if val.match(pattern) then return $1 end
  			end
  		else
  			if value.match(pattern) then return $1 end
  		end
  	else # pattern es nil, devolvemos value at position
  		return value 
  	end
  end
  
#   recojemos dos valores de un csv y hacemos un hash
#	los argumentos pueden ser patterns regexp o posiciones en fila
#	si solo se pasa arg 1 hacemos array simple
  def csvFromValues(value1, value2=nil)
	if @csvParsedFile.nil? then rise 'no csv file stream' end
  	@csvParsedFile.each do |row|
  		puts row
  		valOfValue1 = getValue(row, value1, value1)
# 		puts row[3]
# 		puts valOfValue1
  		valOfValue2 = getValue(row, value2, value2) unless value2.nil?
  		#puts valOfValue2
  		rowValues = value2.nil? ? valOfValue1 : [valOfValue1, valOfValue2]

  		puts rowValues
  		@newCSVArray.push rowValues
  	end
  	@newCSVArray
  end
  
  
  def makeHash(value1, value2)
  	if value1.nil? or value2.nil? then rise 'pasar dos indices' end
  	hash = {}
  	@newCSVArray.each{|row| hash[row[value1]]=row[value2] }
  	hash
  end
  
  
  
  def makeArray(value, value2=nil, value3=nil)
  	if value.nil?  then rise 'pasar indice' end
  	array = []
  	values = []
  	values.push value 
  	values.push value2 unless value2.nil?
  	values.push value3 unless value3.nil?
  	
  	@newCSVArray.each do |row|
  		vals = values.collect{|v| row[v]}
  		array.push vals
  	end
  	array
  end
  	
  
  def removeValue(row, pattern=nil, position=nil)
  
  end
  		
    
  def writeNewCSV(pathToNewCsv=nil)
  	path = pathToNewCsv.nil? ? @csvFileName[0,@csvFileName.length-4]<<'__withNewValue.csv' : pathToNewCsv
    csvOut = CsvOutput.new(path,'|')
    
	array = @newCSVArray.nil? ? @csvParsedFile : @newCSVArray
  # puts array
    array.each do |row|
      # puts row.inspect
    	csvOut.write(row)
    end

    csvOut.close
    return File.size?(path) ?  1 : nil 
  end 
 
end

