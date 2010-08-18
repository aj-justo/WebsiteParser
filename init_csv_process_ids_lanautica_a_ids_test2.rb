require 'csvProcess.rb'

p_lanautica = ProcessCSV.new('/Users/angeljusto/Desktop/lanautica-ids-models-products.csv', '|')
p_test2 = ProcessCSV.new('/Users/angeljusto/Desktop/test2-nuevos-products.csv', '|')

# products_description = ProcessCSV.new('/Users/angeljusto/Desktop/lanautica-products_description.csv', '|')
# products_to_categories = ProcessCSV.new('/Users/angeljusto/Desktop/lanautica-products_to_categories.csv', '|')

l_model_to_id = p_lanautica.makeHash(1,0)
t_model_to_id = p_test2.makeHash(1,0)

# array with old id to new id
old_to_new_ids = {}
t_model_to_id.each_pair do |model,new_id|
  old_id = l_model_to_id[model]
  old_to_new_ids[old_id] = new_id
end

p_test2.newCSVArray = old_to_new_ids
p_test2.writeNewCSV('/Users/angeljusto/Desktop/test2_products_old_to_new_ids.csv')