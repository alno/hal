class Hal::DefinitionBuilder

  class UnknownControllerError < StandardError; end

  def import_package(pkg)
    pkg.controller_definitions.each do |name, resolver|
      if controller_definitions.key? name
        raise StandardError, "Controller #{name} already defined"
      else
        controller_definitions[name] = resolver
      end
    end
  end

  def controller_definitions
    @controller_definitions ||= {}
  end

  def resolve_controller(name, node_type, options)
    if (resolver = controller_definitions[name])
      [resolver.call(node_type, options), options]
    else
      raise UnknownControllerError, "Unknown controller #{name}"
    end
  end

  def build(&block)
    builder = NodeBuilder.new(self, :group, '', Hal::Path.root)
    builder.apply(&block)

    Hal::Definition.new(builder.result)
  end

  class NodeBuilder

    attr_reader :type, :path
    attr_accessor :options

    def initialize(def_builder, type, name, path)
      @def_builder = def_builder
      @type = type
      @name = name
      @path = path
      @options = options
      @children = {}
      @controllers = []
    end

    def apply(&block)
      NodeDsl.new(self).instance_eval(&block)
    end

    def add_controller(name, **controller_options)
      @controllers << @def_builder.resolve_controller(name, @type, controller_options)
    end

    def add_child(type, name, *controllers, **options, &block)
      name = name.to_s

      builder = NodeBuilder.new(@def_builder, type, name, @path / name)
      builder.options = options

      # Register controllers
      controllers.each { |c, **opts| builder.add_controller c, **opts }

      # Call block
      builder.apply(&block) if block

      @children[name] = builder.result
    end

    def result
      Hal::Definition::Node.new(@type, @name, @path, @options, @controllers, @children)
    end

  end

  class NodeDsl

    def initialize(builder)
      @builder = builder
    end

    Hal::NodeTypes::TYPES.each do |type|
      define_method type do |name, *controllers, **options, &block|
        @builder.add_child type, name, *controllers, **options, &block
      end
    end

    def controller(name, **options)
      @builder.add_controller name, **options
    end

  end

end
