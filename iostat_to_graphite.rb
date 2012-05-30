#!/usr/bin/env ruby
#
# run with something like iostat -nx 10 | iostat_to_graphite.rb
# modified to work on rackspace virtual servers

# http://www.cyberciti.biz/tips/linux-disk-performance-monitoring-howto.html

# Get this from https://github.com/SmartReceipt/graphite_reporter
require 'graphite_reporter'

ENV['GRAPHITE_HOST'] = 'graphite01'
ENV['GRAPHITE_PORT'] = '2005'
ENV['GRAPHITE_PROTOCOL'] = 'upd'

ARGF.each do |line|
  if (line ~ /^xvd/) then
    values = line.split(' ')
    device_name = values.pop
    #prefix = "#{hostname}.iostat.#{values.pop}"
    %w{rrqmps wrpmpw rps wps rsecps wsecps avgrqsz avgqusz await svctm putil}.each do |stat|
      GraphiteReporter :name => "iostat.#{device_name}", :key => stat :value => values.pop
    end
end
