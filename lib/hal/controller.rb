module Hal::Controller
  autoload :Base, 'hal/controller/base'
  autoload :OnewireGauge, 'hal/controller/onewire_gauge'
  autoload :OnewireSwitch, 'hal/controller/onewire_switch'
  autoload :MotionCamera, 'hal/controller/motion_camera'

  def self.resolve(type, controller)
    case [controller, type]
    when [:onewire, :gauge] then OnewireGauge
    when [:onewire, :switch] then OnewireSwitch
    when [:motion, :camera] then MotionCamera
    else raise StandardError, "Couldn't resolve controller #{controller.inspect} for #{type.inspect} node"
    end
  end
end
