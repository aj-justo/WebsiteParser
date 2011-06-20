require '../url.rb'
require "test/unit"


class UrlTest < Test::Unit::TestCase  
  
  def test_getDomainUrl
    assert_equal 'http://www.osculati.com/', Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=19314').getDomainUrl

  end
  
  def test_getUrl
    assert_equal 'http://www.osculati.com/cat/Serieweb.aspx?id=19314' , Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=19314').url
  end
  
  def test_newUrlBaseUrlValue
    assert_not_nil Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=19314').getBaseUrl
  end
  

  
  def test_getNewDomainUrl
    assert_equal 'http://www.osculati.com/cat/Scheda.aspx?id=2360', Url.new('http://www.osculati.com/cat/Serieweb.aspx?id=19314').getNewDomainUrl('Scheda.aspx?id=2360')
  end
  
end