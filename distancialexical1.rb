#Função Lexical para comparar strings
 
#Vamos usar a distância de Levenshtein
 
def distancia_lexical(str1,str2)
	lev1, lev2 = str1.length, str2.length
	return lev2 if lev1 == 0
	return lev1 if lev2 == 0
 
	cost = (0..lev1).to_a
	new_cost = [0] * (lev1 + 1)
 
	(1..lev2).each do |i|
		new_cost[0] = i
 
		(1..lev1).each do |j|
			substituir_cost = str1[j - 1] == str2[i - 1] ? 0 : 1
			new_cost[j] = [new_cost[j - 1] + 1, cost[j] + 1, cost[j - 1] + substituir_cost].min
		end
 
		cost, new_cost = new_cost, cost
	end
 
	return cost[lev1]
 
end
 
#Perguntar qual são as strings
 
puts "Entre com a primeira string: "
string1 = gets.chomp.to_s
 
puts "Entre com a segunda string: "
string2 = gets.chomp.to_s
 
distancia = distancia_lexical(string1, string2)
 
puts "A distância lexical entre '#{string1}' e '#{string2}' é : #{distancia}"