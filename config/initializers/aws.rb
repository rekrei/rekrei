AWS_CONFIG = YAML.load(ERB.new(File.read(File.join(::Rails.root,"config","aws.yml"))).result)[Rails.env]
