require 'csvProcess.rb'

catalogo = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_todo_limpio.csv', '|')
prices = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_prices.csv', ',')
prices.csvFromValues(0, 1)

# limpiamos de simbolos monetarios etc y convertimos comas a puntos
prices.newCSVArray.each do |array|
# 	puts array[1]
	array[1].match(/([0-9,.]+)/)
	array[1] = $1
	unless array[1].nil?
		array[1].gsub!('.','')
		array[1].gsub!(',','.')
		array[1]=array[1].to_f
		if array[1]<100 then array[1]=array[1]+(array[1]*10/100) end
	end
# 	puts array[1]
	# subimos un 10% todos los precios por debajo de 100 eur
	
# 	puts array[1]
end




#  un hash para simplificar el loop del catalogo
pricesHash={}
prices.newCSVArray.each do |array|
	pricesHash[array[0]] = array[1]
end

# para cada linea del catalogo comprobar si concuerda ID y ese caso a–adir precio a la fila
catalogo.csvParsedFile.each do |row|
	id = row[0]
	if pricesHash.has_key? id
		row.push pricesHash[id]
	end
	unless row.nil?
		catalogo.newCSVArray.push(row)
	end
	puts row
end
	
catalogo.writeNewCSV('/Users/angeljusto/Desktop/osculati_todo_limpio_con_precios.csv')