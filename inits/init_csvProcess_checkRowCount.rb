require 'csvProcess.rb'

tablaProductos = ProcessCSV.new('/Users/angeljusto/Desktop/insercion_osculati_products_table_OK_con_images.csv', '|')


tablaProductos.newCSVArray.each do |row|
	if !row.length==42 then puts row[3] end
end
	