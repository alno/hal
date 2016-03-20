class Hal::DefinitionBuilder

  class UnknownControllerError < StandardError; end

  def import_package(pkg)
    pkg.controller_definitions.each do |name, resolver|
      if controller_definitions.has_key? name
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
    if resolver = controller_definitions[name]
      [resolver.call(node_type, options), options]
    else
      raise UnknownControllerError, "Unknown controller #{name}"
    end
  end

  def build(&block)
    children = Hash.new
    resolved_controllers = Array.new

    # Build child nodes in dsl block
    NodeBuilder.new(self, :group, '', resolved_controllers, children).instance_eval(&block) if block

    Hal::Definition.new(Hal::Definition::Node.new(:group, '', '', {}, resolved_controllers, children))
  end

  def build_node(type, name, basepath, *controllers, **options, &block)
    name = name.to_s
    path = \
      if basepath && !basepath.empty?
        "#{basepath}/#{name}"
      else
        name
      end

    children = Hash.new
    resolved_controllers = controllers.map{ |n, **opts| resolve_controller(n, type, **opts) }

    # Build child nodes in dsl block
    NodeBuilder.new(self, type, path, resolved_controllers, children).instance_eval(&block) if block

    Hal::Definition::Node.new(type, name, path, options, resolved_controllers, children)
  end

  class NodeBuilder

    def initialize(def_builder, type, path, resolved_controllers, children)
      @def_builder = def_builder
      @type = type
      @path = path
      @children = children
      @resolved_controllers = resolved_controllers
    end

    Hal::NodeTypes::TYPES.each do |type|
      define_method type do |name, *controllers, **options, &block|
        name = name.to_s

        @children[name] = @def_builder.build_node(type, name, @path, *controllers, **options, &block)
      end
    end

    def controller(name, **options)
      @resolved_controllers << @def_builder.resolve_controller(name, @type, options)
    end

  end

end
