require 'csv'
require 'csvOutput.rb'

class RemoveDuplicates  
  def initialize(csvFile)
    if csvFile.nil? then rise 'No csvFile passed' end
    @csvFile = csvFile
    file = CSV::Reader.parse(File.open(@csvFile,'r+b'), '|')
    @cleanArray = []
    file.each do |row|
      if row[0].match(/[0-9]+\.[0-9]+\.[0-9]+.?/) or row[0].include?('ID')
        unless @cleanArray.include?(row)
          @cleanArray.push row
          puts row[0]
        end
      end
    end
    puts @cleanArray.length
    writeCleanCsv
  end
  
  def writeCleanCsv
    cleanCsv=@csvFile[0,@csvFile.length-4]<<'__clean.csv'
    csvOut = CsvOutput.new(cleanCsv,'|')
    @cleanArray.each do |row|
      csvOut.write(row)
    end
  end
  
end

RemoveDuplicates.new('/path/to/new/csvfile.csv')