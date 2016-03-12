$:.unshift('./lib')

require './app'

# Require sprockets in dev mode
unless production?
  Sinatra::Sprockets.configure do |config|
    config.compile = false         # On-the-fly compilation
    config.compress = false        # Compress assets
    config.digest = false          # Append a digest to URLs
    config.css_compressor = false  # CSS compressor instance
    config.js_compressor = false   # JS compressor instance
  end

  map "/#{Sinatra::Sprockets.config.prefix}" do
    run Sinatra::Sprockets.environment
  end
end

run Sinatra::Application
