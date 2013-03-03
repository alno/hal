
require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'
require 'zurb-foundation'
require 'slim'

require 'database'
require 'config'
require 'camera'
require 'record'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname __FILE__
    config.sass_dir = File.join "views", "sass"
    config.images_dir = File.join "views", "images"
    config.http_path = "/"
    config.http_images_path = "/images"
    config.http_stylesheets_path = "/css"
  end

  set :sass, Compass.sass_engine_options
end

helpers do

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

get "/css/*.css" do |path|
  content_type "text/css", charset: "utf-8"
  sass :"sass/#{path}"
end
