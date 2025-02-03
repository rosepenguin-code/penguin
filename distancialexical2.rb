# Função para calcular a distância de Levenshtein entre duas strings
def distancia_lexical(str1, str2)
  m = str1.length
  n = str2.length
 
  d = Array.new(m+1) { Array.new(n+1) }
 
  (0..m).each { |i| d[i][0] = i }
  (0..n).each { |j| d[0][j] = j }
 
  (1..m).each do |i|
    (1..n).each do |j|
      cost = str1[i-1] == str2[j-1] ? 0 : 1
      d[i][j] = [
        d[i-1][j] + 1,     # eliminação de partes
        d[i][j-1] + 1,     # inserção de partes
        d[i-1][j-1] + cost # substituição
      ].min
    end
  end
 
  d[m][n]
end
 
# Função para ler os ficheiros e retornar a lista de linhas
def read_log_file(file_path)
  File.readlines(file_path, encoding: 'utf-8')
end
 
# Função para comparar as linhas dos dois ficheiros
def compara_log_lines(log1_lines, log2_lines)
  diferencas = []
 
  log1_lines.each_with_index do |line1, index|
    line2 = log2_lines[index] || "" # Se o ficheiro 2 tiver menos linhas, considerar vazio
    distancia = distancia_lexical(line1, line2)
 
    if distancia > 0
      diferencas << { line1: line1, line2: line2, distancia: distancia }
    end
  end
 
  diferencas
end
 
# Função para analisar as diferenças e identificar potenciais vulnerabilidades
def analise_vulnerabilidade(diferencas)
  vulnerabilidades = []
 
  diferencas.each do |diff|
    # Analise simplificada de diferenças entre as linhas
    if diff[:distancia] > 100 # Analisa o valor da distância
      vulnerabilidades << {
        message: "Diferença significativa encontrada",
        line1: diff[:line1],
        line2: diff[:line2],
        distancia: diff[:distancia]
      }
    end
  end
 
  vulnerabilidades
end
 
# Função para gravar o resultado
def grava_analise(vulnerabilidades, file_output)
  File.open(file_output, 'w') do |file|
    file.puts " - Análise de Vulnerabilidade - "
    vulnerabilidades.each do |vulnerability|
      file.puts "#{vulnerability[:message]}"
      file.puts "Linha do ficheiro 1: #{vulnerability[:line1]}"
      file.puts "Linha do ficheiro 2: #{vulnerability[:line2]}"
      file.puts "Distância: #{vulnerability[:distancia]}"
      file.puts "------------------"
    end
  end
end
 
# Informar o caminho dos ficheiros
file1_path = "logwindows.txt"
file2_path = "logwindows2.txt"
file_output = "resultado_analise_lexical.txt"
 
# Ler os ficheiros de log
log1_lines = read_log_file(file1_path)
log2_lines = read_log_file(file2_path)
 
# Comparar os ficheiros
diferencas = compara_log_lines(log1_lines, log2_lines)
 
# Chamar a análise de vulnerabilidade
vulnerabilidades = analise_vulnerabilidade(diferencas)
 
# Guardar em ficheiro
grava_analise(vulnerabilidades, file_output)
 
# Exibir os resultados
puts " - Análise de Vulnerabilidade - "
vulnerabilidades.each do |vulnerability|
  puts "#{vulnerability[:message]}"
  puts "Linha do ficheiro 1: #{vulnerability[:line1]}"
  puts "Linha do ficheiro 2: #{vulnerability[:line2]}"
  puts "Distância: #{vulnerability[:distancia]}"
  puts "------------------"
end
 
puts "-" * 50
puts "Análise Finalizada. Ficheiro de saída é: #{file_output}"