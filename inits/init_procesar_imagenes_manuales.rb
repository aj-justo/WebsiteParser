require 'csvOutput.rb'

imgDir = Dir.new('/Users/angeljusto/Desktop/todas_fotos_osculati_1_y_2')
imgs = imgDir.entries

csv = CsvOutput.new('/Users/angeljusto/Desktop/images_manuales_todas.csv', ';')

imgsSql = []
imgs.each do |i|
    modelo = i.slice(0,i.length-4)
    if modelo.nil? then next end
      
    modelo = modelo.tr_s(' ', '')
    if modelo.count('.') > 2
      # una imagen secundaria, cojemos su modelo quitando el último .dd.jpg
      modeloArr = modelo.split('.')
      modelo = modeloArr.slice(0,3).join('.')
      imgsSql.push "UPDATE products SET products_subimage_1 = '#{i}' WHERE products_model = '#{modelo}'"
    else
      imgsSql.push "UPDATE products SET products_image = '#{i}' WHERE products_model = '#{modelo}'"
    end
end
  
csv.write(imgsSql)