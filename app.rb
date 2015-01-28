
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

DEVICE_VIEWS = {
  OnewireGauge => :'devices/gauge',
  Camera => :'devices/camera',
  Hal::Group => :'devices/group'
}

get '/history.json' do
  @nodes = params[:nodes].map{ |p| SYSTEM.find(p) }

  json @nodes.map{ |n| n.history.values_as_json(params[:from] && Time.at(params[:from].to_i / 1000), params[:to] && Time.at(params[:to].to_i / 1000)) }
end

post '/light/on' do
  `owwrite /12.34D533000000/PIO.A 1`
end

post '/light/off' do
  `owwrite /12.34D533000000/PIO.A 0`
end

def normalize_path(path)
  path ||= ''

  while path.start_with? '/'
    path = path[1..-1]
  end

  path
end

get '*/cameras' do |path|
  @section = :devices

  @path = normalize_path path
  @node = SYSTEM.find(path) or halt 404

  halt 404 unless @node.respond_to? :children

  slim :'dashboards/cameras'
end

get '*/records' do |path|
  @section = :devices

  @path = normalize_path path
  @node = SYSTEM.find(path) or halt 404

  halt 404 unless @node.respond_to?(:children) || @node.respond_to?(:records)

  slim :'dashboards/records'
end

get '*' do |path|
  @section = :devices

  @path = normalize_path path
  @node = SYSTEM.find(path) or halt 404

  slim DEVICE_VIEWS[@node.class]
end
