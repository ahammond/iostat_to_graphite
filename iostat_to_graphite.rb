#!/usr/bin/env ruby
#
# Run with something like iostat -nx 10 | iostat_to_graphite.rb
#
# In order to make the move to integers clean, all values multiplied by 100
#
# Modified to work on rackspace virtual servers. See
# http://www.cyberciti.biz/tips/linux-disk-performance-monitoring-howto.html
# for info about the different outputs.
#

require 'rubygems'
# Get this module from https://github.com/SmartReceipt/graphite_reporter
require 'graphite_reporter'

ENV['GRAPHITE_HOST'] = 'graphite01'
ENV['GRAPHITE_PORT'] = '2005'
ENV['GRAPHITE_PROTOCOL'] = 'udp'

ARGF.each do |line|
  if line =~ /^xvd/
    values = line.split(' ')
    device_name = values.shift
    %w{rrqmps wrpmpw rps wps rsecps wsecps avgrqsz avgqusz await svctm putil}.each do |stat|
      GraphiteReporter.call(:key => "iostat",
                            :name => "#{device_name}_#{stat}_x100",
                            :value => Integer(Float(values.shift) * 100))
    end
  end
end