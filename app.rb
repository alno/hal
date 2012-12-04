
require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'
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
      "http://hal.local/cameras/#{parts[-2]}/records/files/#{parts[-1]}"
    else
      "/cameras/#{parts[-2]}/records/files/#{parts[-1]}"
    end
  end

  def records
    db[:camera_events.as(:thumb)].join(:camera_events.as(:video), :video__event => :thumb__event).
      where(:thumb__file_type => 1, :video__file_type => 8).
      select(:thumb__event, :thumb__file_name => :thumb_path, :video__file_name => :video_path)
  end

  def camera_records(camera)
    records.where(:thumb__camera => cameras.index(camera) + 1)
  end

end

get '/' do
  slim :dashboard
end

get '/cameras' do
  slim :cameras
end

get '/cameras/:camera' do |camera|
  halt 404 unless cameras.include? camera

  @camera = camera

  slim :camera
end

get '/cameras/:camera/records' do |camera|
  halt 404 unless cameras.include? camera

  @camera = camera
  @records = camera_records(camera).all

  puts @records.inspect

  slim :records
end

get '/cameras/:camera/stream' do |camera|
  halt 404 unless cameras.include? camera

  "There should be MJPEG stream"
end

get '/cameras/:camera/records/files/*path' do |camera, path|
  halt 404 unless cameras.include? camera

  "There should be NGINX camera records handler"
end

get "/css/*.css" do |path|
  content_type "text/css", charset: "utf-8"
  sass :"sass/#{path}"
end
