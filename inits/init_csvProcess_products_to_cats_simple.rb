require 'csvProcess.rb'

# frances = ProcessCSV.new('/Users/angeljusto/Desktop/nombres_descs_frances_con_modelo.csv', '|')
 ids = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/productsproducts_ids_and_model.csv', '|')
products_to_cats = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/osculati_todo_limpio_con_precios.csv', '|')

# cat_to_model = products_to_cats.makeHash(2,0)
model_to_cat = products_to_cats.makeHash(0,2)
# model_to_id = ids.makeHash(1,0)
id_to_model = ids.makeHash(0,1)
id_to_model.each_pair do |id,model|
  id_to_model[id] = model_to_cat[model]
end


# cat_to_model.each_pair do |cat, model|
#   cat_to_model[cat]= model_to_id[model]
# end
# puts cat_to_model.length

products_to_cats.newCSVArray = id_to_model
products_to_cats.writeNewCSV('/Users/angeljusto/Desktop/products_to_categories_NEW_NEW.csv')


