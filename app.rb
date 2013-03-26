
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/sprockets'
require 'sinatra/json'
require 'slim'

require 'database'
require 'config'
require 'camera'
require 'record'
require 'gauge'

Sinatra.register Sinatra::Sprockets

Sinatra::Sprockets.configure do |config|
  config.compile = false         # On-the-fly compilation
  config.compress = false        # Compress assets
  config.digest = false          # Append a digest to URLs
  config.css_compressor = false  # CSS compressor instance
  config.js_compressor = false   # JS compressor instance
end

get '/' do
  slim :dashboard
end

get '/cameras' do
  @section = :cameras

  slim :'cameras/index'
end

get '/cameras/:id' do |id|
  @section = :cameras
  @camera = Camera.find(id) or halt 404

  slim :'cameras/show'
end

get '/records' do
  @section = :records

  @records = Record.all

  slim :'records/list'
end

get '/records/:id' do |id|
  @section = :records
  @camera = Camera.find(id) or halt 404

  @records = @camera.records

  slim :'records/list'
end

get '/cameras/:id/stream' do |id|
  Camera.find(id) or halt 404

  "There should be MJPEG stream"
end

get '/records/:id/files/*path' do |id, path|
  Camera.find(id) or halt 404

  "There should be NGINX camera records handler"
end

get '/gauges/:id' do |id|
  @section = :gauges
  @gauge = Gauge.find(id) or halt 404

  slim :'gauges/show'
end

get '/gauges/:id/data' do |id|
  @gauge = Gauge.find(id) or halt 404

  json @gauge.values_as_json
end
