class Hal::View::Base
  attr_reader :node, :children

  def initialize(node, path, children)
    @node = node
    @path = path
    @children = children
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

end
