require 'csvProcess.rb'

prods = ProcessCSV.new('/Users/angeljusto/PROYECTOS_A/lanautica/insercion_masiva_productos/OSCULATI/OSCULATI_OK/osculati_importaciones_productos/osculati_todo_limpio__clean.csv', '|')

ids = ProcessCSV.new('/Users/angeljusto/PROYECTOS_A/lanautica/insercion_masiva_productos/OSCULATI/OSCULATI_OK/osculati_importaciones_productos/productsproducts_ids_and_model.csv', '|')

model_to_id = ids.makeHash(1,0)

descs = prods.makeArray(0,11,12)

descs.each do |p|
  model = p[0]
  p[0] = model_to_id[model]
end

prods.newCSVArray = descs
prods.writeNewCSV('/Users/angeljusto/Desktop/products_description_english.csv')