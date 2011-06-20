$LOAD_PATH << '../'
require 'csvProcess.rb'
require "test/unit"


class CsvProcess_test < Test::Unit::TestCase  
  
  def test_writeNewCSV
  	csv = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_prices.csv', ',')
  	csv.newCSVArray=[1,2,3,4,5,6,7,8,9]
    assert_not_nil csv.writeNewCSV('/Users/angeljusto/Desktop/osculati_prices__testing.csv')

  end
  
	def test_csvFromValues
  	tablaProductos = ProcessCSV.new('/Users/angeljusto/Desktop/insercion_osculati_products_table.csv', '|')

	assert_not_nil tablaProductos.csvFromValues(1)
	end
end