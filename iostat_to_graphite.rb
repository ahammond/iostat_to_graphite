#!/opt/csw/bin/ruby
#
# run with something like iostat -nx 10 | iostat_to_graphite.rb
#

require 'socket'

graphite_host='graphite'
graphite_port=2003

hostname=`hostname`.chomp


ARGF.each do |line|
    tstamp = Time.now.to_i
    if (line !~ /extended device|r\/s/) then
       s = TCPSocket.open(graphite_host, graphite_port)
       parts = line.split(' ')
       device = parts[10].gsub(/[\/\(\): ]/,'_')
       prefix = "servers.#{hostname}.iostat.#{device}"
       s.puts "#{prefix}.reads_sec #{parts[0]} #{tstamp}" 
       s.puts "#{prefix}.writes_sec #{parts[1]} #{tstamp}" 
       s.puts "#{prefix}.kreads_sec #{parts[2]} #{tstamp}" 
       s.puts "#{prefix}.kwrites_sec #{parts[3]} #{tstamp}" 
       s.puts "#{prefix}.pc_wait #{parts[8]} #{tstamp}" 
       s.puts "#{prefix}.pc_busy #{parts[9]} #{tstamp}" 
       s.close
    
    end
end
