require 'csvProcess.rb'

prods = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/osculati_todo_limpio__clean.csv', '|')

ids = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/productsproducts_ids_and_model.csv', '|')

model_to_id = ids.makeHash(1,0)

descs = prods.makeArray(0,6,7)

descs.each do |p|
  model = p[0]
  p[0] = model_to_id[model]
end

prods.newCSVArray = descs
prods.writeNewCSV('/Users/angeljusto/Desktop/nueva_relacion_products_description_frances.csv')