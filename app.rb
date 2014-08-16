require 'sinatra'
require_relative 'lib/dns_updater'

get '/update/:ip' do
  DnsUpdater.update(params[:ip])
end
