class Hal::Persistor

  attr_reader :bus, :path

  def initialize(bus, path)
    @bus = bus
    @path = path
  end

  def start
  end

  def stop
  end

end
