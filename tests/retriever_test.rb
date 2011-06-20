# addElements(elementCss, elementsPerPage=nil)
$LOAD_PATH << '../'
require 'retriever.rb'
require 'osculati.rb'
require 'csvOutput.rb'
require "test/unit"


class RetrieverTest < Test::Unit::TestCase  
  
  def test_addElements
    assert_equal [['table.tabdati', 1]], Osculati.new( CsvOutput.new('/Users/aj/Desktop/osculati')).addElements('table.tabdati',1)
  end
  
  def test_getElements
    
  end

end