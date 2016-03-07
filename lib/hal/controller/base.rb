class Hal::Controller::Base
  attr_reader :bus, :node, :options

  def initialize(bus, node, options)
    @bus = bus
    @node = node
    @options = options
  end

  def start
  end

  def stop
  end

end