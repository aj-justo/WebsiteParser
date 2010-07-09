require 'rubygems'
require 'mechanize' 
require 'nokogiri'

class Retriever
    
  public
  def initialize(login=nil)
    @agent = getMechanizeAgent
    if login.nil? then
      @login=false 
    else
      @login = true
      @logged = false
    end
#    elementos html a buscar en la pagina a parsear
    @elements = []
#    array de datos econtrados para pasar a output object
#  compuesto a modo de filas para csv etc
    @dataArray = []
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
    # if(@login.defined? == nil) then
    #         @login = get_mechanize_agent
    #       end      
    if (loginUrl.nil? or loginUser.nil? or loginPass.nil?) then rise 'Se requiere url, usuario y clave' end
    @loginUrl = loginUrl
    @loginUser = loginUser
    @loginPass = loginPass
   
    page = @agent.get loginUrl
    
    form = page.forms.first
    form.admin_name = loginUser
    form.admin_pass = loginPass
#      form.securityToken = form.securityToken
    form.add_field!('submit', '1')
    # debugger
    @agent.submit form 
    @logged = true
    @agent
    # if(agent.url.contains? login.php) not-being-logged->error
    # else @login = 1
  end
  
  public
  def parsePage(url)
    if @loginRequired and !@logged then
      begin 
        login(@loginUrl, @loginUser, @loginPass)
      end
    end
    @page = @agent.get url 
    parseElements
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
      @page.search(value).each{|el|
         getElementData(el)
      }
    }   
  end

# overloading en subclases especificas para cada web
  private
  def getElementData(element)
    @dataArray.push element.inner_text
  end
  
  public
  def getDataArray
    @dataArray
  end
  
  public 
  def output(outputObject=nil)
    unless outputObject.nil? then @outputObject = outputObject end
    @outputObject
  end

  
  
end

