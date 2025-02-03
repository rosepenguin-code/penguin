#Analisar Filestamps dentro da pasta
 
#usar uma gema para validar o timestamps
require 'fileutils'
 
#caminho onde irá validar os ficheiros
directory_path = 'c:\Windows\System32'
 
#Validar se o diretorio existe
unless Dir.exist?(directory_path)
	puts "O caminho informado não existe"
	exit
end
 
def collect_timestamps(directory_path)
	#Criar um arry para armazenamento
	timestamps = []
 
	#Analisar os ficheiros dentro do diretório informado
	Dir.foreach(directory_path) do |file|
		next if file == '.' || file == '..' #ignorar as referencias de diretório
 
		file_path = File.join(directory_path, file)
 
	  begin
		if File.directory?(file_path)
			#Caso seja um  diretorio ele vai analisar o timestamp
			timestamps += collect_timestamps(file_path)
		  else
		  	#Se for um ficheiro, coletar o timestamp
		  	timestamps << "#{file}: #{File.mtime(file_path)}"
		end
	  rescue Errno::EACCES
		#caso o diretório seja protegido, o scrip vai pular o diretório	
		puts "Acesso negado no diretório #{file_path}. Ignorar este diretório/ficheiro"
 
	  end
	end
 
	timestamps #Retorna todos os timestamps coletados
end
 
timestamps = collect_timestamps(directory_path)
 
#Criar o ficheiro com o resultado
output_file = "timestamps_result.txt"
File.open(output_file,'w') do |f|
	timestamps.each do |timestamp|
		f.puts timestamp
	end
end
 
puts "A analise de Timestamps terminou e foi guardada em: #{output_file}"