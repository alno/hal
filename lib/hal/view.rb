module Hal::View
  autoload :Base, 'hal/view/base'
  autoload :Group, 'hal/view/group'
  autoload :Gauge, 'hal/view/gauge'
  autoload :Switch, 'hal/view/switch'
  autoload :Camera, 'hal/view/camera'

  def self.create(node, path = '')
    children = node.children.map{ |k, v| [k, create(v, Hal::Util.join(path, k))] }

    view_class = const_get(Hal::Util.camelize(node.type).to_sym)
    view_class.new(node, path, Hash[children])
  end
end
