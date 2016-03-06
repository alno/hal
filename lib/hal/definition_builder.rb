module Hal
  class DefinitionBuilder

    def build(&block)
      children = Hash.new
      controllers = Array.new

      # Build child nodes in dsl block
      NodeBuilder.new(self, '', controllers, children).instance_eval(&block) if block

      Definition.new(Definition::Node.new(:group, '', '', controllers, children))
    end

    def build_node(type, name, basepath, controllers, &block)
      name = name.to_s
      path = \
        if basepath && !basepath.empty?
          "#{basepath}/#{name}"
        else
          name
        end

      children = Hash.new

      # Build child nodes in dsl block
      NodeBuilder.new(self, path, controllers, children).instance_eval(&block) if block

      Definition::Node.new(type, name, path, controllers, children)
    end

    def controllers_from_args(args)
      Array.new.tap do |controllers|
        args.each_slice 2 do |slice|
          raise StandardError, "Controller options should be a Hash" if slice[1] && !slice[1].is_a?(Hash)

          controllers << slice
        end
      end
    end

    class NodeBuilder

      def initialize(def_builder, path, controllers, children)
        @def_builder = def_builder
        @path = path
        @children = children
        @controllers = controllers
      end

      Hal::NodeTypes::TYPES.each do |type|
        define_method type do |name, *args, &block|
          name = name.to_s
          @children[name] = @def_builder.build_node(type, name, @path, @def_builder.controllers_from_args(args), &block)
        end
      end

    end

  end
end
