require 'socket'
 
def ipv6_address?(host)
	socket = TCPSocket.new(host,80)
	true
  rescue SocketError, Errno::ECONNEREFUSED
  	false
  ensure
  	socket.close if socket
end
 
puts "Digite o site para validação do IPv6:"
host = gets.chomp
 
if ipv6_address?(host)
	puts "O site #{host} possui IPv6"
else
	puts "O IPv6 não está disponível no host informado"
end