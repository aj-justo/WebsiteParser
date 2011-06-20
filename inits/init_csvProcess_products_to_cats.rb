require 'csvProcess.rb'

# frances = ProcessCSV.new('/Users/angeljusto/Desktop/nombres_descs_frances_con_modelo.csv', '|')
 ids = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/productsproducts_ids_and_model.csv', '|')
products_to_cats = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/osculati_todo_limpio_con_precios.csv', '|')

#  arrays tipo ['24032']=>Anclas, ['24031']=>Anclas (varios ids a mismo nombre)
catsIds = products_to_cats.makeHash(1,3)
subcatsIds = products_to_cats.makeHash(2,5)
subcatsIds.merge!(subcatsIds)

subcatsParents = products_to_cats.makeHash(2,1)

#  arrays tipo ['Anclas'] => 21024 (un único nombre a un único id)
catsNames = products_to_cats.makeHash(3,1)
subcatsNames = products_to_cats.makeHash(5,2)
subcatsNames.merge!(catsNames)

# un hash que contiene categorias unicas
subcatsNamesUnique = {}
subcatsNames.each do |val,id|
	unless subcatsNamesUnique.keys.include? val	
		subcatsNamesUnique[val]=id
	end
end	

#  recorremos los productos:
 # 1. cojer nombre de cat de subcatsIds
 # 2. con ese nombre cojemos id único de subcatsNames
 # 3. volvemos a guardar el producto con este ID de subcat

model_and_cat = products_to_cats.makeHash(0,2)
id_and_model = ids.makeHash(1,0)
id_and_cat = []

model_and_cat.each_pair do |model,cat|
	catNombre = subcatsIds[cat]
	if catNombre.nil? 
	  cat = subcatsParents[cat]
	  catNombre= subcatsIds[cat]
	else
	  catNombre.chop!
	end
	catUniqueId = subcatsNamesUnique[catNombre]
  # si no encontramos id unique le ponemos id de categoria superior
	if catUniqueId.nil? 
	  catUniqueId = subcatsParents[cat]
	else
	  model_and_cat[model] = catUniqueId
	end
	
  # cambiamos modelo por id
  id_and_cat.push [id_and_model[model], catUniqueId]
end

products_to_cats.newCSVArray = id_and_cat

products_to_cats.writeNewCSV('/Users/angeljusto/Desktop/products_to_categories_NEW.csv')

# products_to_cats.newCSVArray = []
# subcatsNamesUnique.each_pair do |k,v|
#   products_to_cats.newCSVArray.push []
#   products_to_cats.newCSVArray[-1] = [k,v]
# end
# 
# products_to_cats.writeNewCSV('/Users/angeljusto/Desktop/relacion_categorias_unique_testing.csv')
# 
# 

