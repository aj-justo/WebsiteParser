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
  
    @elements = {}
#    if (website.nil? or !website.class 'Url') then rise 'No se ha pasado un objeto Url' end
#    @website = website;
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
  def getElements(name, elementCss)
    if name.nil? or elementCss.nil? then raise 'nombre y elemento son imprescindibles' end
    @elements[name] = elementCss
  end
  
  private
  def parseElements
    if @page.nil? then raise 'primero hay que parsear la pagina' end
    if @elements.nil? then raise 'primero hay que definir elementos a parsear con getElements' end
    @elements.each_pair{|key,value|
      @page.search(value).each{|el|
          getData(el)
      }
    }
  end

  private
  def getData(element)
    outputData(Nokogiri.parse(element).inner_text)
  end
  
  public 
  def output(outputObject)
    @outputObject = outputObject
  end
  
  public
  def getOutput
    @outputObject
  end
  
  private
  def outputData(dataArray) 
    @outputObject.write(dataArray)
  end
  
end

