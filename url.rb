class Url
  
  public
  def initialize(baseUrl)
#    deal with urls y con files
    @baseUrl='/'
    @baseCategoryUrl=''
    @baseProductUrl=''
    @category=''
    @completeUrl=''
    
    if baseUrl.nil? then raise "no url passed" end
    @baseUrl = baseUrl
  end
  
  private
  def getBaseUrl()
    @baseUrl
  end
  
  private 
  def setBaseUrl(newBase=nil, suffix=nil)
    unless newBase.nil? then
      @baseUrl = newBase
    end
    unless suffix.nil? then
      @baseUrl << suffix
    end
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