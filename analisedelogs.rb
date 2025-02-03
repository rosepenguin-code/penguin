require 'rubygems'
require 'win32/eventlog'
include Win32
 
log_file_path = 'logwindows.txt'
 
begin
  File.open(log_file_path, 'w') do |file|
    EventLog.open('Application') do |log|
      log.read(EventLog::SEQUENTIAL_READ | EventLog::FORWARDS_READ) do |record|
        file.puts "Event ID: #{record.event_id}"
        file.puts "Source: #{record.source}"
        file.puts "Description: #{record.description}"
        file.puts "-" * 50  
      end
    end
  end
 
  puts "Os registros do log foram guardados em #{log_file_path}"
 
rescue => e
  puts "Ocorreu um erro: #{e.message}"
  puts e.backtrace.join("\n")
end
tem menu de contexto