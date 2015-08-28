FLICKR_CONFIG = YAML.load(ERB.new(File.read(File.join(Rails.root,'config', 'flickr.yml'))).result)[Rails.env]

FlickRaw.api_key = FLICKR_CONFIG[:key]
FlickRaw.shared_secret = FLICKR_CONFIG[:secret]
