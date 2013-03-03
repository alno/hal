
require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'
require 'zurb-foundation'
require 'slim'

require 'database'
require 'config'
require 'camera'

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

  def db
    DB
  end

  def file_url(path)
    parts = path.split('/')

    APP_CONFIG['urls']['record'].gsub(':camera', parts[-2]).gsub(':path', parts[-1])
  end

  def records
    db[:camera_events.as(:thumb)].join(:camera_events.as(:video), :video__event => :thumb__event).
      where(:thumb__file_type => 1, :video__file_type => 8).
      select(:thumb__event, :thumb__file_name => :thumb_path, :video__file_name => :video_path, :video__time => :time).
      order{ video__time.desc }
  end

  def camera_records(camera)
    records.where(:thumb__camera => camera.index, :video__camera => camera.index)
  end

  def last_records
    records.limit(4)
  end

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

  @records = records.all

  slim :'records/list'
end

get '/records/:id' do |id|
  @section = :records
  @camera = Camera.find(id) or halt 404

  @records = camera_records(@camera).all

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
