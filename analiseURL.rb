require "net/ping"

good = "http://foryou.pt/index.php"
bad = "http://www.ruby-lang.org//index.html"

puts "=-= Teste de ping em URSs =-="

puts "=-= URL correta, redirecionamento =-="
p1 = Net::Ping::HTTP.new(good)
puts "Ping bem sucessido: #{p1.ping?}"

puts "=-= URl com problema"
p2 = Net::Ping:HTTP.new(bad)
puts "Ping bem sucessido: #{p2.ping?}"
puts "Aviso: #{p2.warning}"
puts "Exceção: #{p2.exception}"
