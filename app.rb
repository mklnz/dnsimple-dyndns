require 'rubygems'
require 'bundler/setup'

# require 'byebug'

require 'dnsimple'
require 'active_support'
require 'active_support/core_ext'
require 'yaml'
require 'open-uri'

require_relative 'lib/dnsimple_dyndns'

dnsimple_dyndns = DnsimpleDyndns.new
dnsimple_dyndns.load_config
dnsimple_dyndns.update_all
