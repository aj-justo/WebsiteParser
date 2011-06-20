require 'csvProcess.rb'

prices = ProcessCSV.new('/Users/angeljusto/Desktop/TARIFALIVEMAR2010.csv', '|')
model_to_price = prices.makeHash(0, 1)

ids = ProcessCSV.new('/Users/angeljusto/Desktop/livemar_db.csv', '|')
models_to_ids = ids.makeHash(1,0)

encontrados = Hash.new
prefijos = ['FN', 'FN-']

# articulos en db: quitamos el prefijo "ge, GE, GM," etc
new_models_to_ids = Hash.new
models_to_ids.each_pair do |model,id|
  model = model[2,model.length]
  new_models_to_ids[model] = id
end
#puts new_models_to_ids.inspect

# a la tarifa original, le quitamos los puntos tal como hicieron en lanautica al insertar
# y para cada articulo buscamos si esta en db

# new_models_to_ids.each_pair do |m,id| 
#   m=m.slice(2..m.length)
#   unless model_to_price.keys.include?(m)
#     puts m
#   end
# end


model_to_price.each_pair do |modeloOrig, price|
  unless modeloOrig.nil? then
    modeloOrig = modeloOrig.gsub('.','') 
    if new_models_to_ids.keys.include?(modeloOrig) or
       new_models_to_ids.keys.include?('00'+modeloOrig) or
       new_models_to_ids.keys.include?('0'+modeloOrig)      
        price = price.sub(',','.').to_f*1.7
        encontrados[modeloOrig] = price
        new_models_to_ids.delete(modeloOrig)
        #puts encontrados['GE'+modeloOrig]
    else 
      puts 'no encontrado: '+modeloOrig
    end
  end
end
#puts encontrados.inspect
#puts new_models_to_ids.keys - encontrados.keys
prices.newCSVArray = encontrados
prices.writeNewCSV('/Users/angeljusto/Desktop/livemar.csv')