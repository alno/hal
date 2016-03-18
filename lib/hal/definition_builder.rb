class Hal::DefinitionBuilder

  def build(&block)
    children = Hash.new
    controllers = Array.new

    # Build child nodes in dsl block
    NodeBuilder.new(self, '', controllers, children).instance_eval(&block) if block

    Hal::Definition.new(Hal::Definition::Node.new(:group, '', '', {}, controllers, children))
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

    # Build child nodes in dsl block
    NodeBuilder.new(self, path, controllers, children).instance_eval(&block) if block

    Hal::Definition::Node.new(type, name, path, options, controllers, children)
  end

  class NodeBuilder

    def initialize(def_builder, path, controllers, children)
      @def_builder = def_builder
      @path = path
      @children = children
      @controllers = controllers
    end

    Hal::NodeTypes::TYPES.each do |type|
      define_method type do |name, *controllers, **options, &block|
        name = name.to_s
        @children[name] = @def_builder.build_node(type, name, @path, *controllers, **options, &block)
      end
    end

    def controller(name, options = {})
      @controllers << [name, options]
    end

  end

end
