#Analisar Filestamps dentro da pasta
 
#usar uma gema para validar o timestamps
require 'fileutils'
 
#caminho onde irá validar os ficheiros
directory_path = 'C:\Windows\System32'
 
#Validar se o diretorio existe
 
unless Dir.exist?(directory_path)
	puts "O caminho informado não existe"
	exit
end
 
#Criar um arry para armazenamento
timestamps = []
 
#Analisar os ficheiros dentro do diretório informado
Dir.foreach(directory_path) do |file|
	next if file == '.' || file == '..' #ignorar as referencias de diretório
 
	file_path = "#{directory_path}/#{file}"
	timestamps << "#{file}: #{File.mtime(file_path)}"
end
 
#Criar o ficheiro com o resultado
output_file = "timestamps_resultado.txt"
File.open(output_file,'w') do |f|
	timestamps.each do |timestamp|
		f.puts timestamp
	end
end
 
puts "A analise de Timestamps terminou e foi guardada em: #{output_file}" 