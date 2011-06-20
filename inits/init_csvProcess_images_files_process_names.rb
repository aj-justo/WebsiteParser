require 'csvProcess.rb'

tablaProductos = ProcessCSV.new('/Users/angeljusto/Desktop/insercion_osculati_products_table_OK.csv', '|')

imgDir = Dir.new('/Users/angeljusto/Desktop/images')
imgs = imgDir.entries

serieSufixes = ['.xx', '.xxb']
extensions = ['.jpg', '.png', '.gif']

tablaProductos.newCSVArray.each do |row|
	
	modelo=row[3]
	currentImg=row[4]
	
	lastDotPos = modelo.index('.', 5)
# 	cojemos "02.031"
	serie = modelo[0,lastDotPos]
# 	cojemos ".42"
	modeloCode = modelo[lastDotPos, modelo.length-1]
	

# 	variaciones: 02.031.42, 02.031.41-42, 02.031.42-41, 02.031.42b, 02.031.41.42b, 02.031.42-41b, 02.031.xx, 02.031.xxb
	variations = []
	serieSufixes.each{|s|
		variations.push serie + s
	} 
	variations.push serie + modeloCode
#   	puts variations.inspect
# 	primero, comprobar si hay una concordancia exacta para evitar hacer regexp
	found=nil

# 	no encontrada, probamos variaciones con regexp: .41-42, .41(lo-que-sea), .loquesea-42
	imgs.each do |i|
		unless i.match(/#{serie}.+#{modeloCode}/).nil?
			row[4] = i 
			found = 1
			next
		end
		unless i.match(/#{serie}#{modeloCode}.+/).nil?
			row[4] = i 
			found = 1
			next
		end
		variations.each do |v|
			extensions.each do |x|
				unless i.match(/#{v}.+#{x}/).nil?
					row[4] = i 
					found = 1
					next
				end
			end
		end
# 		ultimo recurso, cualquier imagen que comienze igual que serie
		if found.nil? 
			unless i.match(/#{serie}.+/).nil?
				row[4] = i 
				found = 1
			end
		end		
	end
	unless found==1 then puts modelo end
end
	
tablaProductos.writeNewCSV('/Users/angeljusto/Desktop/insercion_osculati_products_table_OK_con_images_procesadas.csv')