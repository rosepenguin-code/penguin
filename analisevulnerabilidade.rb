# Função para ler e analisar o ficheiro analise_botnet.txt
def analyze_file(filename)
  content = File.read(filename)
  vulnerabilities = []

  # Análise das informações do sistema
  system_info_match = content.match(/Informações do Sistema:\n(.*?)\n\n/m)
  if system_info_match
    system_info = system_info_match[1]
    os_version_match = system_info.match(/os_version: (\d+\.\d+\.\d+)/)
    if os_version_match
      os_version = os_version_match[1]
      if os_version < '10.0.19041'
        vulnerabilities << "Sistema Operativo desatualizado. Versão atual: #{os_version}. Recomendado: 10.0.19041 ou superior."
      end
    else
      vulnerabilities << "Não foi possível obter a versão do sistema operativo."
    end
  else
    vulnerabilities << "Seção de Informações do Sistema não encontrada no ficheiro."
  end

  # Análise dos processos em execução e suas linhas de comando
  processes = content.scan(/:name=>"(.*?)", :pid=>(\d+), :command_line=>"(.*?)"/)
  suspicious_processes = []

  processes.each do |process|
    name = process[0]
    pid = process[1]
    command_line = process[2]

    if command_line.nil? || command_line.empty?
      suspicious_processes << "#{name} (PID: #{pid}): Linha de comando vazia ou não acessível."
    elsif command_line =~ /\/c\s+/
      suspicious_processes << "#{name} (PID: #{pid}): Uso potencial do interpretador de comando para executar comandos externos."
    end
  end

  vulnerabilities << suspicious_processes unless suspicious_processes.empty?

  # Análise das portas abertas
  open_ports = content.scan(/^TCP\s+.*?LISTENING$/)
  open_ports.each do |port|
    if port.match(/TCP\s+0\.0\.0\.0:445/)
      vulnerabilities << "Porta 445 aberta. Porta comumente explorada. Considere desativá-la se não for necessária."
    elsif port.match(/TCP\s+0\.0\.0\.0:8080/)
      vulnerabilities << "Porta 8080 aberta. Verifique qual serviço está a usar esta porta e certifique-se de que está configurada de forma segura."
    end
  end

  # Análise das informações de rede
  network_info = content.scan(/{:description=>.*?:dns_servers=>"(.*?)"/)
  network_info.each do |adapter|
    dns_servers = adapter[0].split(', ')
    if dns_servers != ['8.8.8.8', '8.8.4.4']
      vulnerabilities << "Servidores DNS não padrão detetados: #{dns_servers.join(', ')}. Verifique se esta configuração foi intencional."
    end
  end

  vulnerabilities.flatten
end

# Função principal para executar a análise e exibir os resultados
def main
  filename = 'possiveis_botnet.txt'
  vulnerabilities = analyze_file(filename)

  if vulnerabilities.empty?
    puts "Nenhuma vulnerabilidade identificada."
  else
    puts "/// Potenciais Vulnerabilidades Identificadas: ///"
    vulnerabilities.each { |vulnerability| puts "- #{vulnerability}" }
  end
end

main