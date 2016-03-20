module Hal::Controller

  autoload :Base, 'hal/controller/base'
  autoload :OnewireGauge, 'hal/controller/onewire_gauge'
  autoload :OnewireSwitch, 'hal/controller/onewire_switch'
  autoload :MotionCamera, 'hal/controller/motion_camera'
  autoload :GpioContact, 'hal/controller/gpio_contact'

  def self.resolve(name)
    factories[name]
  end

  def self.define(name, &factory)
    factories[name] = factory
  end

  private

  def self.factories
    @factories ||= {}
  end

end
