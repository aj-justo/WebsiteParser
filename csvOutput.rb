# extiende retriever para usar output a csv
class CsvOutput
   
  public
  def initialize(path,dataArray)
    require 'csv'
    @fecha = Time.now
    @csvFile = File.open(path<<@fecha.to_s<<".csv", 'wb')
    @dataArray = dataArray
  end
  
  
  public
  def write
#    print @dataArray.inspect
    @dataArray.each{|row|
#    print row.inspect
      writeRow(row)
    }
  end
  
  private
  def writeRow(row)
    CSV::Writer.generate(@csvFile, '|') do |csv|
#        puts "writing: #{row[0]}"
        csv << row
    end
  end
  
  
end