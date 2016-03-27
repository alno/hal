module Hal::View
  autoload :Base, 'hal/view/base'
  autoload :Group, 'hal/view/group'
  autoload :Gauge, 'hal/view/gauge'
  autoload :Switch, 'hal/view/switch'
  autoload :Camera, 'hal/view/camera'
  autoload :Contact, 'hal/view/contact'

  def self.create(bus, node, path = '')
    path = Hal::Path[path]
    children = node.children.map { |k, v| [k, create(bus, v, path / k)] }

    view_class = const_get(Hal::Util.camelize(node.type).to_sym)
    view_class.new(bus, node, path, Hash[children])
  end
end
