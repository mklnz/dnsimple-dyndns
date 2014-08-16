require 'sinatra'
require_relative 'lib/dns_updater'

set :bind, '0.0.0.0'

config = YAML.load_file(File.join(__dir__, "config/config.yml"))

get '/update/:ip' do
  if params[:s] == config["server_secret"]
    DnsUpdater.update(params[:ip])
    "UPDATED"
  end
end
