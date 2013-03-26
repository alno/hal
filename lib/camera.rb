require 'config'

Camera = Struct.new :id, :index, :name do

  def self.all
    @cameras ||= APP_CONFIG['cameras'].map { |id, data|
      self.new id, data['index'], data['name']
    }
  end

  def self.each(&block)
    all.each(&block)
  end

  def self.find(id)
    all.find { |cam| cam.id == id }
  end

  def stream_url
    APP_CONFIG['urls']['camera'].gsub(':camera', id)
  end

  def records
    Record.where(:thumb__camera => index, :video__camera => index)
  end

end
