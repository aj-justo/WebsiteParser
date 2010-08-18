require 'csvProcess.rb'

# catalogo = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_todo_limpio.csv', '|')
categorias = ProcessCSV.new('/Users/angeljusto/Desktop/subcats_cats_para_procesar.csv', '|')


#  solo unicos
subcats = categorias.makeArray(0).uniq!
# puts subcats.inspect
cats = categorias.makeArray(1).uniq!
#  [cat_parent]=cat
relaciones = categorias.makeHash(0,1)

categoriasOK = []

subcats.each do |s|
	categoriasOK.push ['id'=>s, 'parent'=>relaciones[s]]
end

cats.each do |c|
	categoriasOK.push ['id'=>c, 'parent'=>0]
# 	puts categoriasOK[-1]
end

categorias.newCSVArray = []
categoriasOK.each do |c|
 	categorias.newCSVArray.push [c[-1]['id'], c[-1]['parent']]
end

# puts categorias.inspect	
categorias.writeNewCSV('/Users/angeljusto/Desktop/osculati_categorias_ok.csv')