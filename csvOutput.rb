# extiende retriever para usar output a csv
class CsvOutput
   
  public
  def initialize(path,rowLength)
    require 'csv'
    @fecha = Time.now
    @csvFile = File.open(path<<@fecha.to_s<<".csv", 'wb')
    @rowLength = rowLength
  end
  
  public
  def getRowLength
    @rowLength
  end
  
  public
  def write(dataArray)
    rows = dataArray.length/@rowLength
    if rows<1 then rows = 1 end
    rows.times do |i| 
      writeRow(dataArray[i*@rowLength,@rowLength])
    end
  end
  
  private
  def writeRow(row)
    print row
    CSV::Writer.generate(@csvFile, '|') do |csv|
#        puts "writing: #{row[0]}"
        csv << row
    end
  end
  
end