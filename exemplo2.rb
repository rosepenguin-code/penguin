require 'resolv'

def domain_exists?(domain)
  begin
    Resolv::DNS.open do |dns|
      resources = dns.getresources(domain, Resolv::DNS::Resource::IN::A)
      return !resources.empty?
    end
  rescue Resolv::ResolvError, Resolv::ResolvTimeout
    return false
  end
end

puts "Digite o domínio a ser verificado:"
domain = gets.chomp

if domain_exists?(domain)
  puts "O domínio #{domain} existe."
else
  puts "O domínio #{domain} não existe."
end
