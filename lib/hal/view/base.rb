class Hal::View::Base
  attr_reader :bus, :node, :children

  def initialize(bus, node, path, children)
    @bus = bus
    @node = node
    @path = path
    @children = children
  end

  def send_command(cmd)
    bus.publish(Hal::Util.join(node.path, 'commands'), cmd)
  end

  def type
    node.type
  end

  def name
    node.name
  end

  def title
    @title ||= Hal::Util.camelize(name)
  end

  def find(path)
    path.split('/').inject self do |node, segment|
      node && node.children[segment]
    end
  end

  def as_json
    { title: title, type: type }
  end

end
