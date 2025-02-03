require "socket"

def ip_class(ip_address)
	first_octet = ip_address.split(".").first.to_i

	case first_octet
	when 1..126
		ip_class = "A"
		ip_range = "1.0.0.0 - 126.255.255.255"
	when 128..191
		ip_class = "B"
		ip_range = "128.0.0.0 - 191.255.255.255"
	when 192..223
		ip_class = "C"
		ip_range = "192.0.0.0 - 223.255.255.255"
	when 224..239
		ip_class = "D"
		ip_range = "Multicast"
	when 240..255
		ip_class = "E"
		ip_range = "Reservado para o futuro"
	else
		ip_class = "Ip invalido"
		ip_range = "Ip invalido"
	end

		return ip_class, ip_range
end

ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
ip_class, ip_range = ip_class(ip_address)

puts "Endereço de IP: #{ip_address}"
puts "Classe de IP: #{ip_class}"
puts "Range de Ip: #{ip_range}"
		