require 'config'
require 'database'

class Record < Sequel::Model

  set_dataset( DB[:camera_events.as(:thumb)].
    join(:camera_events.as(:video), :video__event => :thumb__event).
    where(:thumb__file_type => 1, :video__file_type => 8).
    select(:thumb__event => :event, :thumb__camera => :camera, :thumb__file_name => :thumb_path, :video__file_name => :video_path, :video__time => :time).
    order{ video__time.desc }
  )

  def video_url
    file_url video_path
  end

  def thumb_url
    file_url thumb_path
  end

  private

  def file_url(path)
    parts = path.split('/')

    APP_CONFIG['urls']['record'].gsub(':camera', parts[-2]).gsub(':path', parts[-1])
  end

end
