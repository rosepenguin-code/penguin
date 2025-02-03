#validar portar abertas no firewall

#executa comando netstat para capturar as saidas
resultado = "netsat -an"

#criar um ficheiro apra armazenar dados
file.open("resultado_firewall.txt", "w") do |file|
	file.write(resultado)
end

put "Verifica a vulnerabilidade e guarda os resultados no ficheiro resultado_firewall.txt"
