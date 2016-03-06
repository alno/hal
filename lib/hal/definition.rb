module Hal
  class Definition
    class Node
      attr_reader :type, :name, :path, :controllers, :children

      def initialize(type, name, path, controllers, children)
        @type = type
        @name = name
        @path = path
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

    private

    def collect_controllers(node)
      controllers = node.controllers.map{ |c, o| [node.path, c, o] }

      node.children.each_value do |c|
        controllers += collect_controllers(c)
      end

      controllers
    end
  end
end
