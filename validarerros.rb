#Código de validação de erros do sistema operativo
require 'open3'
 
def validar_erros
	erros = []
 
	#Listar erros da máquina 
	stdout, stderr, status = Open3.capture3('sfc /scannow')
 
	#Verificar se temos erros
	if status.success?
		erros << "Nenhum erro encontrado."
	   else
	    erros << "Erros encontrados: #{stderr} e #{stdout}"
	end	
 
	#Gravar o erro encontrado
	File.open('erros_windows.txt', 'w') { |file| file.write(erros.join("\n")) }
end
 
#Chamar o método
validar_erros