class Hal::Controller
  attr_reader :bus, :path, :options

  def initialize(bus, path, options)
    @bus = bus
    @path = path
    @options = options
  end

  def start
  end

  def stop
  end

end
