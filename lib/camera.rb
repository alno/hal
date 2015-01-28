require 'config'

Camera = Struct.new :id, :index, :name do

  def stream_url
    APP_CONFIG['urls']['camera'].gsub(':camera', id)
  end

  def records
    Record.where(:thumb__camera => index, :video__camera => index)
  end

end
