require 'resolv'
require "whois"

def email_valido?(email)
	valida = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	email.match?(valida)
end

def dominio_valido?(email)
	dominio = email.split('@').last  
	mx_records = Resolv::DNS.open do |dns|
		dns.getresources(dominio, Resolv::DNS::Resource::IN::MX)
	end
	!mx_records.empty?
end

#ip do dominio e provedor de hospedagem

def obter_informacoes_dominio(email)
	dominio = email.split('@').last

	ip = Resolv.getaddress(dominio) rescue nil

#info hospedagem site

	cliente = Whois::Client.new
	record = cliente.lookup(dominio)

	provedor_hospedagem = record.contacts.map {|contact| contact.organization}.compac.join(",") rescue "Não está disponível"
	{ip:ip, provedor_hospedagem: provedor_hospedagem}
end

def validar_email
	puts "Digite um email válido"
	email = gets.chomp

	if email_valido?(email)
		if dominio_valido?(email)
			puts "O email é válido e o domínio está a funcionar."
			info = obter_informacoes_dominio(email)
			puts "O endereço de IP do domínio: #{info[:ip]}"
			puts "O provedor de hospedagem: #{info[:provedor_hospedagem]}"
		else
			puts "O email é válido, mas o domínio não possui registo MX."
		end
	else
		puts "O email fornecido não é válido."
	end
end

validar_email

