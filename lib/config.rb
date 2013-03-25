require 'yaml'

APP_CONFIG_FILE = File.open(File.expand_path('../config/application.yml', File.dirname(__FILE__)))
APP_CONFIG = YAML.load(APP_CONFIG_FILE)[ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development']
