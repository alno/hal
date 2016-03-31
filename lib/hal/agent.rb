class Hal::Agent
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

  private

  def subscribe(path, method_name)
    bus.subscribe(expand_path(path), method(method_name))
  end

  def unsubscribe(path, method_name)
    bus.unsubscribe(expand_path(path), method(method_name))
  end

  def expand_path(path)
    path = Hal::Path[path]

    if path.absolute?
      path
    else
      node.path / path
    end
  end
end
