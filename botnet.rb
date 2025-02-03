require 'win32ole'
 
#Primeira função para obter informações do sistema operativo (Windows)
def system_info
	wmi = WIN32OLE.connect("winmgmts://")
	computer_system = wmi.ExecQuery("SELECT * FROM Win32_ComputerSystem").to_enum.first
	os = wmi.ExecQuery("SELECT * FROM Win32_OperatingSystem").to_enum.first
 
	#mostra as informações do sistema operativo
	{
		hostname: computer_system.Name,
		manufacturer: computer_system.Manufacturer, 
		model: computer_system.Model,
		os_name: os.Caption,
		os_version: os.Version, 
		os_build_number:  os.BuildNumber  
	}
end
 
#Função para obter a lista de processos em execução
def running_processes
	wmi = WIN32OLE.connect("winmgmts://")
	processes = wmi.ExecQuery("SELECT * FROM Win32_Process").to_enum
	processes.map { |process| { name: process.Name, pid: process.ProcessId, command_line: process.CommandLine } }
end
 
#Função para obter informações de uso da Rede 
def network_info
	wmi = WIN32OLE.connect("winmgmts://")
	adapters = wmi.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True").to_enum
	adapters.map do |adapter|
		{
			description: adapter.Description,
			mac_address: adapter.MACAddress,
			ip_address: adapter.IPAddress.join(", "),
			subnet_mask: adapter.IPSubnet.join(", "), 
			default_gateway: adapter.DefaultIPGateway ? adapter.DefaultIPGateway.join(", ") : "N/A",
			dns_servers: adapter.DNSServerSearchOrder ? adapter.DNSServerSearchOrder.join(", ") : "N/A"
		}
	end
end
 
#Função para listar as portas abertas NetStat
def list_open_ports
	open_ports = 'netstat -an'
	open_ports.split("\n").select { |line| line.include?("LISTEN")}
end
 
#Função para guardar em ficheiro o resultado apresentado
def save_results(filename, content)
	File.open(filename, 'w') do |file|
		file.write(content)
	end
end
 
#Exibir o resultado
def format_results
	results = ""
 
	results << "Informações do sistema:\n"
	results << system_info.map { |k, v| "#{k}: #{v}" }.join("\n")
	results << "\n\nProcessos em Execução:\n"
	running_processes.each { |process| results << "#{process}\n" }
	results << "\nPortas Abertas:\n"
	list_open_ports.each { |port| results << "#{port}\n"}
	results << "\nInformação de Rede:\n"
	network_info.each { |adapter| results << "#{adapter}\n" }
 
	results 
end
 
#Chamar a função e exibir os resultados
 
results = format_results
 
puts results
save_results('possiveis_botnet.txt', results)