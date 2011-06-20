require 'csvProcess.rb'

oldid_to_newid = ProcessCSV.new('/Users/angeljusto/Desktop/test2_products_old_to_new_ids.csv', '|')

products_description = ProcessCSV.new('/Users/angeljusto/Desktop/lanautica-products_description.csv', '|')
# products_to_categories = ProcessCSV.new('/Users/angeljusto/Desktop/lanautica-products_to_categories.csv', '|')

o_to_n = oldid_to_newid.makeHash(0,1)

newProducts = []
products_description.newCSVArray.each do |p|
# products_to_categories.newCSVArray.each do |p|
  p[0] = o_to_n[p[0]]
  unless p[0].nil? or p[0].length==0
    newProducts.push p
  else
    puts p.inspect
  end
end

products_description.newCSVArray = newProducts
products_description.writeNewCSV('/Users/angeljusto/Desktop/lanautica-products_description_IDSNUEVOS.csv')
# products_to_categories.newCSVArray = newProducts
# products_to_categories.writeNewCSV('/Users/angeljusto/Desktop/lanautica-products_to_categories_IDSNUEVOS.csv')