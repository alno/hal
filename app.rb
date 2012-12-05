
require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'
require 'zurb-foundation'
require 'slim'
require 'database'

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

  def cameras
    @cameras = ['degu', 'door']
  end

  def camera_stream(camera)
    if development?
      "http://hal.local/cameras/#{camera}/stream"
    else
      "/cameras/#{camera}/stream"
    end
  end

  def file_url(path)
    parts = path.split('/')

    if development?
      "http://hal.local/records/#{parts[-2]}/files/#{parts[-1]}"
    else
      "/records/#{parts[-2]}/files/#{parts[-1]}"
    end
  end

  def records
    db[:camera_events.as(:thumb)].join(:camera_events.as(:video), :video__event => :thumb__event).
      where(:thumb__file_type => 1, :video__file_type => 8).
      select(:thumb__event, :thumb__file_name => :thumb_path, :video__file_name => :video_path, :video__time => :time).
      order{ video__time.desc }
  end

  def camera_records(camera)
    cam_index = cameras.index(camera) + 1

    records.where(:thumb__camera => cam_index, :video__camera => cam_index)
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

get '/cameras/:camera' do |camera|
  halt 404 unless cameras.include? camera

  @section = :cameras
  @camera = camera

  slim :'cameras/show'
end

get '/records' do
  @section = :records

  @records = records.all

  slim :'records/list'
end

get '/records/:camera' do |camera|
  halt 404 unless cameras.include? camera

  @section = :records
  @camera = camera
  @records = camera_records(camera).all

  slim :'records/list'
end

get '/cameras/:camera/stream' do |camera|
  halt 404 unless cameras.include? camera

  "There should be MJPEG stream"
end

get '/records/:camera/files/*path' do |camera, path|
  halt 404 unless cameras.include? camera

  "There should be NGINX camera records handler"
end

get "/css/*.css" do |path|
  content_type "text/css", charset: "utf-8"
  sass :"sass/#{path}"
end
