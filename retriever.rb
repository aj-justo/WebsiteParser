require 'rubygems'
I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = 1
require 'mechanize' 
require 'nokogiri'
require "jcode"

class Retriever
    
  public
  def initialize(output=nil)
    @agent = getMechanizeAgent
    
#    elementos html a buscar en la pagina a parsear
    @elements = []
#    array de datos econtrados para pasar a output object
#  compuesto a modo de filas para csv etc
    @dataArray = []   
    @languages = []
    @currentLanguage = ''    
#    css references for links to follow 
    @followLinks = []    
    @url   
    @parsedPages = []
    
    unless output.nil? 
      @output = output
    end
  end

  private
  def getMechanizeAgent
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac FireFox'
    agent
  end
  
  # check if we can already get the page before login 
  public
  def login(loginUrl, loginUser, loginPass)
    @logged = false

    if (loginUrl.nil? or loginUser.nil? or loginPass.nil?) then rise 'Se requiere url, usuario y clave' end
    @loginUrl = loginUrl
    @loginUser = loginUser
    @loginPass = loginPass
   
    page = @agent.get loginUrl
    
    form = page.forms.first
    form.admin_name = loginUser
    form.admin_pass = loginPass
    form.add_field!('submit', '1')
    @agent.submit form 
    @logged = true
    @agent

  end
  
    
  public
  def addLanguage(lang)
    @languages.push lang
  end
  
#  overload para las distintas webs - ¿podemos hacer algo generico via get?
  private
  def setLanguage(language)
    
  end
  
  
  public
  def parsePage(url)
    puts 'url en parsePage:'
    puts url
    if url.is_a?(String)
      url = Url.new(url)
    end
    @url = url
    @page = @agent.get @url.url
    # solo queremos cojer los idiomas si estamos en pagina de productos
    if elementsInPage then
      if @languages.length>0 and !pageAlreadyParsed?(@url.url) then parseLanguagesPages end
    else
      parseElements
    end
  end
  
  
  private
  def logParsedPage(url)
    @parsedPages.push url
  end
  
  
  private
  def pageAlreadyParsed?(url)
    @parsedPages.include? url 
  end
  
  public
  def getParsedPages
    @parsedPages
  end
  
  
  private 
  def elementsInPage
    @elements.each { |e|
      if @page.search(e).length>0
        return 1
      end
      return 0
    }
  end
  
  private
  def parseLanguagesPages
     @languages.each{|lang|
        @page = setLanguage(lang)
        @currentLanguage = lang
        parseElements
      }
      
  end
  
  
  public
  def addElements(elementCss)
    if elementCss.nil? then raise 'elemento imprescindible' end
    @elements.push elementCss
  end
  
  private
  def parseElements
    if @page.nil? then raise 'primero hay que parsear la pagina' end
    if @elements.nil? then raise 'primero hay que definir elementos a parsear con getElements' end
    @elements.each{|value|
      # puts 'buscando elemento en parseElements:'
      # puts value
      @page.search(value).each{|el|
         getElementData(el)
      }
    } 
    # guardamos lo encontrado, reseteamos array de datos y guardamos log de url
    @output.write(@dataArray)
    @dataArray=[]
    logParsedPage(@url.url)
    #   comprobamos si la misma pagina tiene links para follow
    checkLinksToFollow
  end

# overloaded en subclases especificas para cada web
  private
  def getElementData(element)
    @dataArray.push element.inner_text
  end
  
  public
  def getDataArray
    @dataArray
  end
  
  # public 
  # def output(outputObject=nil)
  #   unless outputObject.nil? then @outputObject = outputObject end
  #   @outputObject
  # end


#  METODOS PARA SEGUIR ENLACES O GUARDARLOS A ARRAY
  public
  def addFollow(cssElement)
    @followLinks.push cssElement
  end
  
  private 
  def checkLinksToFollow
    page = @agent.get @url.url
    @followLinks.each{|link|
      page.search(link).each{|l|
        followLink(l.attributes['href'])
      }
    }
  end
  
  
  private 
  def followLink(link)  
    # print link
    parsePage(@url.getNewDomainUrl(link.inner_text))
  end
  
  
end

