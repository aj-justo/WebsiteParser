require 'csv'
require 'csvOutput.rb'

class GetWeights  
  def initialize(csvFile)
    if csvFile.nil? then rise 'No csvFile passed' end
    @csvFile = csvFile
    file = CSV::Reader.parse(File.open(@csvFile,'r+b'), '|')
    @weightsArray = []
    
    file.each do |row|
#       if !row[0].nil? and row[0].match(/[0-9]+\.[0-9]+\.[0-9]+.?/) or row[0].include?('ID')
		if !row[0].nil? and row[0].include?('ID') then row.push 'products_weight' end
      	if !row[7].nil?
      		if row[7].match(/Poids: ?([0-9,.]+)/)
      			peso = $1
      			peso.gsub!(',','.')
      			row.push peso
      			puts peso
      		else
      			row.push '0.0001'
      		end
      	end
      	@weightsArray.push row
        # unless @weightsArray.include?(row)
#           @weightsArray.push row
#           puts row[0]
#         end
#       end
    end
#     puts @weightsArray.length
     writeWeightsToNewCSV
  end
  
  def writeWeightsToNewCSV
    cleanCsv=@csvFile[0,@csvFile.length-4]<<'__clean.csv'
    csvOut = CsvOutput.new(cleanCsv,'|')
    @weightsArray.each do |row|
      csvOut.write(row)
    end
  end
  
end

GetWeights.new('/Users/angeljusto/Desktop/osculati_todo_limpio.csv')