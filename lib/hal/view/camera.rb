require 'database'

class Hal::View::Camera < Hal::View::Base
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

    def as_json
      {time: time, video_url: video_url, thumb_url: thumb_url}
    end

    private

    def file_url(path)
      parts = path.split('/')

      APP_CONFIG['urls']['record'].gsub(':camera', parts[-2]).gsub(':path', parts[-1])
    end

  end

  def self.records(cameras)
    Record.where(:thumb__camera => cameras.map(&:index), :video__camera => cameras.map(&:index))
  end

  def stream_url
    APP_CONFIG['urls']['camera'].gsub(':camera', node.name)
  end

  def index
    @index ||= node.controllers.select{ |c, o| c == :motion }.map{ |c, o| o[:index] } || -1
  end

  def records
    self.class.records([self])
  end

  def as_json
    last_record = records.last
    last_record_json = last_record && last_record.as_json

    super.merge(stream_url: stream_url, last_record: last_record_json)
  end

end
