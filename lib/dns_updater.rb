require 'yaml'
require 'dnsimple'

class DnsUpdater
  def self.update(record_id, ip)
    config = YAML.load_file(File.join(__dir__, "../config/config.yml"))

    DNSimple::Client.username = config["username"]
    DNSimple::Client.api_token = config["api_token"]

    domain = DNSimple::Domain.find(config["domain"])
    record = DNSimple::Record.find(domain, record_id)
    record.content = ip
    record.save
  end
end
