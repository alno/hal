
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/sprockets'
require 'sinatra/json'
require 'slim'

require 'database'
require 'config'
require 'hal'

SYSTEM = Hal.load_definition('config/system.rb')
VIEW = Hal::View.create(SYSTEM.root['home']['room'])

NODE_TYPE_VIEWS = {
  :gauge  => :'devices/gauge',
  :camera => :'devices/camera',
  :group  => :'devices/group'
}

DASHBOARD_VIEWS = {
  'records' => :'dashboards/records',
  'cameras' => :'dashboards/cameras'
}

Sinatra.register Sinatra::Sprockets

get '/history.json' do
  @nodes = params[:nodes].map{ |p| VIEW.find(normalize_path(p)) }

  json @nodes.map{ |n| n.values_as_json(params[:from] && Time.at(params[:from].to_i / 1000), params[:to] && Time.at(params[:to].to_i / 1000)) }
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

# Custom dashboard routes
get '*::dashboard' do |path, dashboard|
  @path = normalize_path path
  @node = VIEW.find(@path) or halt 404
  @dashboard = dashboard

  slim DASHBOARD_VIEWS[dashboard]
end

# System tree routes
get '*' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path) or halt 404

  slim NODE_TYPE_VIEWS[@node.type]
end
