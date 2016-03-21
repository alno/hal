module Hal::Packages::Base
  extend Hal::Package

  define_controller :gpio, contact: Hal::Controller::GpioContact

  define_controller :motion, camera: Hal::Controller::MotionCamera

end
