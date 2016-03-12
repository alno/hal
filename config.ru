$:.unshift('./lib')

require './app'

# Require sprockets in dev mode
unless production?
  require './assets'

  map "/#{Sinatra::Sprockets.config.prefix}" do
    run app_assets
  end
end

run Sinatra::Application
