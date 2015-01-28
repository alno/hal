
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/sprockets'
require 'sinatra/json'
require 'slim'

require 'database'
require 'config'
require 'camera'
require 'record'
require 'system'
require 'opath'

Sinatra.register Sinatra::Sprockets

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

DEVICE_VIEWS = {
  OnewireGauge => :'devices/gauge',
  Hal::Group => :'devices/group'
}

get '/history.json' do
  puts params.inspect

  @nodes = params[:nodes].map{ |p| SYSTEM.find(p) }

  json @nodes.map{ |n| n.history.values_as_json(params[:from] && Time.at(params[:from].to_i / 1000), params[:to] && Time.at(params[:to].to_i / 1000)) }
end

get '/devices' do
  @section = :devices

  @path = ''
  @node = SYSTEM

  slim DEVICE_VIEWS[@node.class]
end

get '/devices/*' do |path|
  @section = :devices

  @path = path
  @node = SYSTEM.find(path) or halt 404

  slim DEVICE_VIEWS[@node.class]
end

post '/light/on' do
  `owwrite /12.34D533000000/PIO.A 1`
end

post '/light/off' do
  `owwrite /12.34D533000000/PIO.A 0`
end
