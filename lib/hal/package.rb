module Hal::Package

  def controller_definitions
    @controller_definitions ||= {}
  end

  def define_controller(name, classes = {}, &block)
    controller_definitions[name] = \
      if block
        block
      elsif !classes.empty?
        ->(node_type, _opts) { classes[node_type] or raise StandardError, "Controller #{name.inspect} supports only nodes of types #{classes.keys.inspect}, but #{node_type.inspect} given" }
      else
        raise StandardError, "Controller factory block or class hash should be specified"
      end
  end

end
