require 'csvOutput.rb'

imgDir = Dir.new('/Users/angeljusto/Desktop/Imagenes.osculati.test2')
imgs = imgDir.entries

imgs.each do |i|
    modelo = i.slice(0,i.length-4)
    if modelo.nil? then next end
      
    modelo = modelo.tr_s(' ', '')
    if modelo.count('.') > 2
      # una imagen secundaria, cojemos su modelo quitando el último .dd.jpg
      modeloArr = modelo.split('.')
      modelo = modeloArr.slice(0,3).join('.')
      puts "UPDATE products SET products_subimage_1 = '#{i}' WHERE products_model = '#{modelo}';"
    else
      puts "UPDATE products SET products_image = '#{i}' WHERE products_model = '#{modelo}';"
    end
end
  
 