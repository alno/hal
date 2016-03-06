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
  end
end
