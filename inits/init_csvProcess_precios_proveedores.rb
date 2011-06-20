require 'csvProcess.rb'

prices = ProcessCSV.new('/Users/angeljusto/Desktop/Tarifa_mayorista_2010_LIVEMAR.csv', '|')
model_to_price = prices.makeHash(0, 1)


model_to_price.each_pair do |model,price|
  # puts 'precio old: '+price
  nuevo_precio = price.to_f+(price.to_f*80/100)
  model_to_price[model] = nuevo_precio
  # puts model_to_price[model].inspect
end

prices.newCSVArray = model_to_price
prices.writeNewCSV('/Users/angeljusto/Desktop/Tarifa_mayorista_2010_LIVEMAR_PRECIO_ACTUALIZADO.csv')