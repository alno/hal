Sinatra::Sprockets.configure do |config|
  config.compile = false         # On-the-fly compilation
  config.compress = false        # Compress assets
  config.digest = false          # Append a digest to URLs
  config.css_compressor = false  # CSS compressor instance
  config.js_compressor = false   # JS compressor instance
end

def app_assets
  Sinatra::Sprockets.environment
end
