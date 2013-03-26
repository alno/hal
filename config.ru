$:.unshift('./lib')

require './app'

map "/#{Sinatra::Sprockets.config.prefix}" do
  foundation = Bundler.load.specs.find{|s| s.name == 'zurb-foundation' }.full_gem_path
  assets = Sinatra::Sprockets.environment

  assets.append_path File.join(foundation, 'js')
  assets.append_path File.join(foundation, 'scss')

  run assets
end

run Sinatra::Application
