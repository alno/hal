
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'slim'

require 'database'
require 'config'
require 'hal'
require 'hal/packages/base'
require 'hal/packages/onewire'

DEFINITION = Hal.load_definition('config/system.rb', [Hal::Packages::Base, Hal::Packages::Onewire, Hal::Packages::Gpio])

runtime = Hal::Runtime.new(DEFINITION)
runtime.start

VIEW = Hal::View.create(runtime.bus, DEFINITION.root['home']['room'])

NODE_TYPE_VIEWS = {
  gauge: :'devices/gauge',
  camera: :'devices/camera',
  group: :'devices/group'
}.freeze

DASHBOARD_VIEWS = {
  'records' => :'dashboards/records',
  'cameras' => :'dashboards/cameras'
}.freeze

get '/history.json' do
  @nodes = params[:nodes].map { |p| VIEW.find(normalize_path(p)) }

  json @nodes.map { |n| n.values_as_json(params[:from] && Time.at(params[:from].to_i / 1000), params[:to] && Time.at(params[:to].to_i / 1000)) }
end

def normalize_path(path)
  path ||= ''
  path = path.gsub %r{\A\/+}, ''

  Hal::Path[path]
end

# Sending commands to items
post '*/commands' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path)

  halt 404 unless @node

  @node.send_command(request.body.read)

  ''
end

# Custom dashboard routes
get '*::dashboard' do |path, dashboard|
  @path = normalize_path path
  @node = VIEW.find(@path)
  @dashboard = dashboard

  halt 404 unless @node

  slim DASHBOARD_VIEWS[dashboard]
end

# System tree routes
get '*.json' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path)

  halt 404 unless @node

  json @node.as_json
end

# System tree routes
get '*' do |path|
  @path = normalize_path path
  @node = VIEW.find(@path)

  halt 404 unless @node

  slim NODE_TYPE_VIEWS[@node.type]
end
