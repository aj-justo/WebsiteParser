require 'csvProcess.rb'

# catalogo = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_todo_limpio.csv', '|')
categorias = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_categorias/cats_y_subcats_unicas_con_parent.csv', '|')

cats_desc = ProcessCSV.new('/Users/angeljusto/Desktop/osculati_importaciones_productos/osculati_todo_limpio.csv', '|')

# el hash contendra el parent pero nos lo vamos cargar y rellenar con el nombre
cats_unicas = categorias.makeHash(0,1)

cat_to_name = cats_desc.makeHash(1,3)
subcat_to_name = cats_desc.makeHash(2,5)

cats_unicas.each_pair do |cat,name|
  # es una categoria
  if cat_to_name.keys.include? cat
    cats_unicas[cat] = cat_to_name[cat]
    puts cat_to_name[cat]
  else
    if subcat_to_name.keys.include? cat
      cats_unicas[cat] = subcat_to_name[cat]
      puts subcat_to_name[cat]
    end
  end
end


categorias.newCSVArray = cats_unicas
# puts categorias.inspect	
categorias.writeNewCSV('/Users/angeljusto/Desktop/osculati_categorias_new_10_agosto.csv')