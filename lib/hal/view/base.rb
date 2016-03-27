require 'forwardable'

class Hal::View::Base
  extend Forwardable

  def_delegators :@node, :type, :name, :options

  attr_reader :bus, :node, :children

  def initialize(bus, node, path, children)
    @bus = bus
    @node = node
    @path = path
    @children = children
  end

  def send_command(cmd)
    bus.publish(path / 'commands', cmd)
  end

  def title
    @title ||= options[:title] || Hal::Util.camelize(name)
  end

  def find(path)
    path.segments.inject self do |node, segment|
      node && node.children[segment]
    end
  end

  def as_json
    { title: title, type: type }
  end

end
