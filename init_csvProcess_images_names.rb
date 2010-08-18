require 'csvProcess.rb'

tablaProductos = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/insercion_osculati_products_table_OK_con_images_procesadas.csv', '|')

# modelos = tablaProductos.csvFromValues(3)
# modelos.each do |modelo|
# 	modelo.gsub!('.', '-')<<'.jpg'
# end

model_to_image = tablaProductos.makeHash(3,4)

tablaProductos.newCSVArray = model_to_image
tablaProductos.writeNewCSV('/Users/angeljusto/Desktop/actualizar_images_desde_mi_procesado.csv')