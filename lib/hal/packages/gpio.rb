module Hal::Packages::Gpio
  extend Hal::Package

  autoload :ContactController, 'hal/packages/gpio/contact_controller'

  define_controller :gpio, contact: Hal::Packages::Gpio::ContactController
end
