# extiende retriever para usar output a csv
class CsvOutput
   
   attr_reader :path
   attr_reader :separator
   attr_reader :csvFile
   
  public
  def initialize(path, separator=nil)
    require 'csv'
    if separator.nil? then separator = '|' end
    @separator = separator
    @fecha = Time.now
    @csvFile = File.open(path, 'ab')
    @cache = []
    @path = path
  end
  
  
  public
  def write(dataArray)
      writeRow(dataArray)
  end
  
  private
  def addToCache(dataArray)
    dataArray.each{|row|
      @cache.push row
    }
  end
  
  private
  def writeRow(row)
  	puts row
    CSV::Writer.generate(@csvFile, @separator) do |csv|
    	csv << row unless row.nil?
    end
  end
  
  public
  def getStringFromCsv
    file = File.open(@path, 'r')
    contents = file.read
    contents
  end
  
	public 
	def close 
		@csvFile.close
	end
  
end