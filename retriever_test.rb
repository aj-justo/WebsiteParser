# addElements(elementCss, elementsPerPage=nil)

require 'retriever.rb'
require 'osculati.rb'
require 'csvOutput.rb'
require "test/unit"


class RetrieverTest < Test::Unit::TestCase  
  
  def test_addElements
    assert_equal [['table.tabdati', 1]], Osculati.new( CsvOutput.new('/Users/angeljusto/Desktop/osculati')).addElements('table.tabdati',1)

  end
  

end