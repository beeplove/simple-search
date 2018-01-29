CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/custom.yml")).result)[Rails.env]
