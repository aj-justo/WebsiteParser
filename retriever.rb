require 'rubygems'
I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = 1
require 'mechanize' 
require 'nokogiri'
require "jcode"

class Retriever
  
  attr_accessor :logOutput
  attr_accessor :directOutputLogging
  attr_accessor :urlsWithNoElements
    
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
    if url.is_a?(String)
      url = Url.new(url)
    end
    @url = url
    puts @url.url
    # puts pageAlreadyParsed?(@url.url)   
    unless pageAlreadyParsed?(@url.url)      
      @page = @agent.get @url.url
      #  antes de parsear  pagina comprobamos si es una pagina que contiene solo links to follow
      if UrlsWithNoElements?(@url.url)
        checkLinksToFollow
      else
        checkLinksToFollow
        if @languages.length>0
          parseLanguagesPages
        else 
          parseElements
        end
      end
    else
      puts 'url ya hecha:'
      puts @url.url
    end
  end
  
  
  private
  def UrlsWithNoElements?(url=nil)
    if url.nil? then url = @url.url end
    r=nil
    unless @urlsWithNoElements.nil?
      @urlsWithNoElements.each{|u|
        if u.match(/^%([^%]+)%$/)
          u = $1
        end
        if url.include?(u) then r = 1 end
      }
    end
    r
  end
  
  # se debe llamar en init para dar el path
  public
  def previousUrlLog(path=nil)
    if !path.nil? and @previousUrlArray.nil?
      @previousUrlArray=File.open(path, 'r').read      
    end
  end
  
  
  private
  def logParsedPage(url, time=nil)
    if time.nil? then time = 'notime' end
    @parsedPages.push [url, time]
    unless @logOutput.nil?
      if time.nil? then time='notime' end 
      data = [url, time]
      @logOutput.write(data)
      if @directOutputLogging then puts data end
    end
  end
  

  
  private
  def pageAlreadyParsed?(url)   
    # puts 'previous log'
    # puts @previousUrlLog
    if @parsedPages.include?(url) then return 1 end
    if !@previousUrlArray.nil? and @previousUrlArray.include?(url) then
      return 1
    end
    return nil
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
    comienzo = Time.now
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
      final = Time.now
      logParsedPage(@url.url, final-comienzo)
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
      # elment[0] contiene nombre (css path) de elemento
      found = @page.search(element[0])     
      if found.length>0
        # element es un array que contiene element css path en [0] y numero de elems en [1]
        if element[1]>1
          # buscamos el mismo elemento i num de veces
          for i in 1..element[1] do
            getElementData(found[0])
          end
        else
          getElementData(found[0])       
        end
      end
    } 
  end

# overloaded en subclases especificas para cada web
  private
  def getElementData(element)
    data = element.inner_text.to_s
    if data.nil? or data.length==0
      data = element.inner_html.to_s
    end
    if @string_a_buscar.nil? then
      @dataArray[@url.url] =  data
    else
      @dataArray[@string_a_buscar] = data
    end
    puts data
    return 1
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
    puts 'link to follow: ' + link
    parsePage(@url.getNewDomainUrl(link.inner_text))
  end
  
  
end

