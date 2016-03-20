module Hal::Package

  def controller_definitions
    @controller_definitions ||= {}
  end

  def define_controller(name, &block)
    controller_definitions[name] = block
  end

end
