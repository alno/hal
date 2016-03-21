module Hal::Packages::Onewire
  extend Hal::Package

  autoload :GaugeController, 'hal/packages/onewire/gauge_controller'
  autoload :SwitchController, 'hal/packages/onewire/switch_controller'

  define_controller :onewire, gauge: Hal::Packages::Onewire::GaugeController, switch: Hal::Packages::Onewire::SwitchController
end
