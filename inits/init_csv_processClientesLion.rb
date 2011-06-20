require 'csvProcess.rb'

clientes = ProcessCSV.new('/Users/angeljusto/Downloads/address_book(2).csv', '|')

# limpiamos de simbolos monetarios etc y convertimos comas a puntos
clientes.newCSVArray.each do |array|
 	puts array.inspect
end


	
#catalogo.writeNewCSV('/Users/angeljusto/Desktop/osculati_todo_limpio_con_precios.csv')