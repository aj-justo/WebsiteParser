require 'url.rb'
require 'osculati.rb'
require 'csvOutput.rb'

url = Url.new('http://www.osculati.com/cat/Scheda.aspx?id=')

url.setCategory('246')

retriever = Osculati.new()
retriever.output( CsvOutput.new('/Users/angeljusto/Desktop/osculati', 10))
retriever.getElements('nombre', 'p.titoloSerie strong')
retriever.getElements('descripcion', 'p.descrizioneSerie')
retriever.getElements('caracteristicas', 'table.tabdati tr')

retriever.parsePage(url.getProductUrl())

#products.each { |p|
#    osculati.getProductUrl()
#    print "\r\n"
#}

# cookie osculati
# IDLang
# fr-FR
# en-US
#<td> <a id="ctl00_lbIT" href="javascript:__doPostBack('ctl00$lbIT','')" style="font-weight:bold;">IT</a></td> 
#<td> <a id="ctl00_lbEN" href="javascript:__doPostBack('ctl00$lbEN','')" style="font-weight:bold;">EN</a></td> 
#<td> <a id="ctl00_lbFR" href="javascript:__doPostBack('ctl00$lbFR','')" style="font-weight:bold;">FR</a></td> 
#<td> <a id="ctl00_lbHR" href="javascript:__doPostBack('ctl00$lbHR','')" style="font-weight:bold;">HR</a></td> 
#<td> <a id="ctl00_lbDE" href="javascript:__doPostBack('ctl00$lbDE','')" style="font-weight:bold;">DE</a></td> 
#<td> <a id="ctl00_lbRU" href="javascript:__doPostBack('ctl00$lbRU','')" style="font-weight:bold;">RU</a></td> 
#<form name="aspnetForm" method="post" action="Scheda.aspx?id=246" onsubmit="javascript:return WebForm_OnSubmit();" id="aspnetForm">  
#<input type="hidden" name="__EVENTTARGET" id="__EVENTTARGET" value="" /> 
#<input type="hidden" name="__EVENTARGUMENT" id="__EVENTARGUMENT" value="" /> 
#<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="wievEgdq9rv9b2OpzY8q9XwilVvH/bS0C+1ZWOCg3o0MEei/cWdOpZuzv40EUgdyGMHCkAcl5BJ35jMFqxSJopdhTA5ofxGnXSS872BoS9UvsxVugwhJ+IOBgQv0uD100l8kT0qNQvEuJ3cT1hEaWt8HNndJ/OY2a1R/Jp9zGbF1P2SALlZnfxhLr4hVJR4pfD06iF7xcxsnQ7i+BE28xwn3FtTpkClRi31mv2ucmmKU+D+bKfBmaK3eW/GQwNLgYJCzFeogMn62pO4EaaQTX+U/mqssL5sWygsnUbMqW7a3aNrjveeO3sM9VeSUmpu4v4+ltCA7MoIJM7x1l5FeTOUJZxpVgXkbk4GV/06Tx6t0w7iRa1ki9LTuuhYpZTN86akxYnoETTzm5kv/wUhs9Nben8sJ169hLleFBlfgldqEPPwBhYl+mwzf5VP5APwhNIWRkC0Ko5iysZh/JCi8gqsx0gvvmxFhW9alpMyJChm6GuSRCWvSFS4/qCtiqO4HqTorTZ9FUI1NfStX2xCmQCfW6Ta+RA9VFBReAnI26yTAI7dAO/s2vkaSIMSTyEsdEnyeeG4CbeL6vqnx5eX8xEQR4jy8MzRjaBkhqnvD4raljLdq5jAUY803sYBYjan/UXz8PxXWoDJ2+RJZbz4TbEAbgF6Xf0xUuQm/c+FogIc7s7hpkawccZai1kVijfpZw5FHnkt+6nJMctrJ6J5APEcvdUWU8rmMA72oOmVk6LmtuPX3YsO9NhYs7rD1cdCW4vIBtDUwY42T7VrpLzyUwrJBOerprgmSctlmUI2nnRTWndckjdHYsPZ69w3+Og0U0sGBI4gFUZHyJ5eUW7dHwsv/qKwiEj1t42+ViA3R8FsN9dlEbQXxpOphiqS/PuBu" /> 
