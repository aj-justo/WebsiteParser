require "jcode"

class Url
  
  public
  def initialize(url)
#    deal with urls y con files
    @baseUrl='/'
    @baseCategoryUrl=''
    @baseProductUrl=''
    @category=''
    @completeUrl=''
    @domain = ''
    @url = url
    
    if url.nil? then raise "no url passed" end
    if matchDomain(url)
      @completeUrl = url
      @domain = @baseUrl = getDomainUrl(url)
    else
      @baseUrl = url
    end
  end
  
  public
  def url
    @url
  end
  
  public
  def getBaseUrl()
    @baseUrl
  end
  
  public 
  def setBaseUrl(newBase=nil, suffix=nil)
    unless newBase.nil? then
      @baseUrl = newBase
    end
    unless suffix.nil? then
      @baseUrl << suffix
    end
  end
  
  public
  def getDomainUrl(url=nil)
    if url.nil? then url = @baseUrl end
    unless @domain.length>0
      @domain = matchDomain(url)
      # unless @domain[-1].include? '/'
      #         @domain=@domain<<'/'
      #       end
    end
    unless @domain[-1,1].include? '/'
      @domain=@domain<<'/'
    end
    @domain
  end
  
  private
  def matchDomain(url)
    regexp = /((http:\/\/)?(www\.)?[a-z0-9-]+\.[a-z]+)/i
    regexp.match(url)
    @domain = $1
  end
  
  
  # completar checkeando que la url tenga sentido
  # uris pasadas pueden ser:
  # absolutas: http://www.domain.com/pamelitos/antes.html - no hacer nada
  # relativas root: /cat/page.html - añadir a dominio url
  #  relativas a pagina actual: page.html - añadir a pagina actual - problema, no sabemos pagina actual. Hacemos un guessing y quitar a url la pagina - page.html o similar o usamos base url
  public
  def getNewDomainUrl(subUrl)
    # subUrl es absoluta, no hacemos nada
    if subUrl.include?(getDomainUrl)
      return subUrl
    end
    
    #  subUrl es relativa a pagina actual: page.html

    if !subUrl[0,1].include?('/')
      # unless @baseUrl.length>0
      baseUrl = @url.split('/')
      baseUrl=baseUrl.slice(0,baseUrl.length-1).join('/')<<'/'
      # end
    end
    
    # subUrl es relativa a dominio: /cat/page.html
    if subUrl[0,1].include?('/')
      if @baseUrl.length>0
        baseUrlArr = @baseUrl.split('/')
        subUrlArr = subUrl.split('/')
        intersection = subUrlArr & baseUrlArr
        subUrlArr.delete_if {|x| intersection.include?(x) }
        subUrl = subUrlArr.join('/')
        if subUrl.match('^\/')
          subUrl = subUrl.slice(1,subUrl.length)
        end
        baseUrl = @baseUrl
      else
        baseUrl = @domain
      end
    end
    @completeUrl = baseUrl<<subUrl
  end
  
#  public
#  def setCategoryUrlBase(catUrlBase)
#    if catUrlBase.length>0 then
#      @baseCategoryUrl = catUrlBase 
#      @completeUrl = getBaseUrl << @baseCategoryUrl
#    end
#  end
  
  public
  def setProductUrlBase(productUrlBase)
    if productUrlBase.length>0 then
      @baseProductUrl = productUrlBase
      setBaseUrl(nil, @baseProductUrl)
    end
  end
  
  public
  def setCategory(cat)
    unless cat.nil? then
      @category = cat
      setBaseUrl(nil, @category)
    end
  end
  
  public
  def getProductUrl(productId=nil)   
    unless productId.nil? then
      # el producto tiene una url propia
      getBaseUrl << productId
    end
    # no tiene url para producto, usamos la base que se supone será la de una categoria
    getBaseUrl
  end
  
end