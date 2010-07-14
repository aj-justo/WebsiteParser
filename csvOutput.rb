# extiende retriever para usar output a csv
class CsvOutput
   
  public
  def initialize(path)
    require 'csv'
    @fecha = Time.now
    @csvFile = File.open(path<<@fecha.to_s<<".csv", 'wb')
    @cache = []
  end
  
  
  private
  def write(@dataArray)
    @dataArray.each{|row|
      puts 'row en csv write:'
      puts row.inspect
      writeRow(row)
    }
  end
  
  private
  def addToCache(dataArray)
    dataArray.each{|row|
      @cache.push row
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