class Hal::Definition
  class Node
    attr_reader :type, :name, :path, :controllers, :options, :children

    def initialize(type, name, path, options, controllers, children)
      @type = type
      @name = name
      @path = path
      @options = options
      @controllers = controllers
      @children = children
    end

    def [](key)
      @children[key]
    end

  end

  attr_reader :root

  def initialize(root)
    @root = root
  end

  def controllers
    @controllers ||= collect_controllers(@root)
  end

  def persistors
    @persistors ||= collect_persistors(@root)
  end

  private

  def collect_controllers(node)
    controllers = node.controllers.map { |c, o| [node, c, o] }

    node.children.each_value do |c|
      controllers += collect_controllers(c)
    end

    controllers
  end

  def collect_persistors(node)
    persistors = [[node, nil, {}]]

    node.children.each_value do |c|
      persistors += collect_persistors(c)
    end

    persistors
  end
end
