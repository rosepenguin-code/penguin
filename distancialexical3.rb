#Calcular a distância  lexical entre duas strings
def distancia_lexical(str1, str2)
  lev1, lev2 = str1.length, str2.length
  return lev2 if lev1 == 0
  return lev1 if lev2 == 0

  cost = Array.new(lev1 + 1) { Array.new(lev2 + 1, 0) }

  (0..lev1).each { |i| cost[i][0] = i }
  (0..lev2).each { |j| cost[0][j] = j }

  (1..lev1).each do |i|
    (1..lev2).each do |j|
      if str1[i - 1] == str2[j - 1]
        cost[i][j] = cost[i - 1][j - 1]
      else
        cost[i][j] = [cost[i - 1][j] + 1, cost[i][j - 1] + 1, cost[i - 1][j - 1] + 1].min
      end
    end
  end

  differences = []
  i, j = lev1, lev2

  while i > 0 && j > 0
    if str1[i - 1] == str2[j - 1]
      i -= 1
      j -= 1
    else
      if cost[i][j] == cost[i - 1][j - 1] + 1
        differences << { char1: str1[i - 1], char2: str2[j - 1] }
        i -= 1
        j -= 1
      elsif cost[i][j] == cost[i - 1][j] + 1
        i -= 1
      else
        j -= 1
      end
    end
  end

  return { distancia: cost[lev1][lev2], differences: differences.reverse }
end

# Perguntar quais são as strings
puts "Entre com a primeira string: "
string1 = gets.chomp.to_s

puts "Entre com a segunda string: "
string2 = gets.chomp.to_s

result = distancia_lexical(string1, string2)

puts "A distância lexical entre '#{string1}' e '#{string2}' é: #{result[:distancia]}"
puts "Letras que devem ser alteradas:"

result[:differences].each do |diff|
  puts "'#{diff[:char1]}' deve ser alterado para '#{diff[:char2]}'"
end