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
#MODIFICADO: filas identificadas por un ID de producto: ['33.39.2']=['33.39.2','a', '01', 'alskdfj']
    @dataArray = {}  
    @keysArray = [] 
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
    else # solo seguirá enlaces
      if !pageAlreadyParsed?(@url.url)
        parseElements
      end
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
      if @outputKeys.nil? 
        # puts 'Escribiendo cabeceras:'
        # puts @keysArray.inspect
        @output.write(@keysArray)
        @outputKeys = true
      end
      @dataArray.each_pair{|key,row| @output.write(row) }     
      @dataArray={}
      logParsedPage(@url.url) 
  end
  
  
  public
  def addElements(elementCss, elementsPerPage=nil)
    if elementsPerPage.nil? then elementsPerPage = 1 end
    if elementCss.nil? then raise 'elemento imprescindible' end
    # @elements.push elementCss
    @elements.push [elementCss, elementsPerPage]
  end
  
  private
  def parseElements
    if @page.nil? then raise 'primero hay que parsear la pagina' end
    if @elements.nil? then raise 'primero hay que definir elementos a parsear con getElements' end
    @elements.each{|element|
      # puts 'buscando elemento en parseElements:'
      # puts value
      found = @page.search(element[0])
      if found.length>0
          if found.length>1
            # puts 'found mayor que 1'
            # puts found.length
          end
        for i in 1..element[1] do
            # puts 'llamando geElementData con:'
            # puts found[0].to_s.slice(0,100)
            getElementData(found[0])
        end
      end
    } 
    # guardamos lo encontrado, reseteamos array de datos y guardamos log de url
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

