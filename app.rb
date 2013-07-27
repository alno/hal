
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

get '/gauges' do
  @section = :gauges
  @gauges = Gauge.all

  slim :'gauges/index'
end

get '/gauges/:id' do |id|
  @section = :gauges
  @gauge = Gauge.find(id) or halt 404

  slim :'gauges/show'
end

get '/gauges/:ids/data' do |ids|
  @gauges = ids.split(' ').map{ |id| Gauge.find(id) } or halt 404

  json @gauges.map{|g| g.values_as_json(params[:from] && Time.at(params[:from].to_i / 1000), params[:to] && Time.at(params[:to].to_i / 1000)) }
end
