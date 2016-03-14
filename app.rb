
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'slim'

require 'database'
require 'config'
require 'hal'

DEFINITION = Hal.load_definition('config/system.rb')

runtime = Hal::Runtime.new(DEFINITION)
runtime.start

VIEW = Hal::View.create(runtime.bus, DEFINITION.root['home']['room'])

NODE_TYPE_VIEWS = {
  :gauge  => :'devices/gauge',
  :camera => :'devices/camera',
  :group  => :'devices/group'
}

DASHBOARD_VIEWS = {
  'records' => :'dashboards/records',
  'cameras' => :'dashboards/cameras'
}

get '/history.json' do
  @nodes = params[:nodes].map{ |p| VIEW.find(normalize_path(p)) }

  json @nodes.map{ |n| n.values_as_json(params[:from] && Time.at(params[:from].to_i / 1000), params[:to] && Time.at(params[:to].to_i / 1000)) }
end

def normalize_path(path)
  path ||= ''

  while path.start_with? '/'
    path = path[1..-1]
  end

  path
end

# Sending commands to items
post '*/commands' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path) or halt 404

  @node.send_command(request.body.read)

  ''
end

# Custom dashboard routes
get '*::dashboard' do |path, dashboard|
  @path = normalize_path path
  @node = VIEW.find(@path) or halt 404
  @dashboard = dashboard

  slim DASHBOARD_VIEWS[dashboard]
end

# System tree routes
get '*.json' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path) or halt 404

  json @node.as_json
end

# System tree routes
get '*' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path) or halt 404

  slim NODE_TYPE_VIEWS[@node.type]
end
