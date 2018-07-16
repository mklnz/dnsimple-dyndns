class DnsimpleDyndns
  CONFIG_PATH = File.expand_path('../../config', __FILE__)
  CONFIG_FILE = File.join(CONFIG_PATH, 'config.yml')
  TTL = 60

  attr_accessor :config

  def load_config
    self.config = YAML.load_file(CONFIG_FILE).with_indifferent_access
  end

  def save_config
    File.open(CONFIG_FILE, 'w') { |f| f.write(config.to_hash.to_yaml) }
  end

  def client(access_token)
    Dnsimple::Client.new(access_token: access_token)
  end

  def record(entry)
    client(entry[:access_token]).zones.record(
      entry[:account_id], entry[:domain], entry[:record_id]
    )
  end

  def update_record(entry)
    client(entry[:access_token]).zones.update_record(
      entry[:account_id],
      entry[:domain],
      entry[:record_id],
      content: config[:wan_ip], ttl: entry[:ttl] || TTL
    )
  end

  def check_and_update_record(entry)
    remote_ip = record(entry).data.content
    return if remote_ip == config[:wan_ip]
    update_record(entry)
  end

  def current_wan_ip
    open('https://api.ipify.org').read
  end

  def update_all
    config[:wan_ip] = current_wan_ip
    config[:updated_at] = Time.current.to_s

    config[:entries].each do |entry|
      check_and_update_record(entry)
    end

    save_config
  end
end
