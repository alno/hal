module Hal::Packages::Base
  extend Hal::Package

  define_controller :onewire do |node_type, options|
    case node_type
    when :gauge then Hal::Controller::OnewireGauge
    when :switch then Hal::Controller::OnewireSwitch
    else raise StandardError, "Onewire controller supports only gauge and switch nodes, #{node_type} given"
    end
  end

  define_controller :gpio do |node_type, options|
    case node_type
    when :contact then Hal::Controller::GpioContact
    else raise StandardError, "Gpio controller supports only contact nodes, #{node_type} given"
    end
  end

  define_controller :motion do |node_type, options|
    case node_type
    when :camera then Hal::Controller::MotionCamera
    else raise StandardError, "Motion controller supports only camera nodes, #{node_type} given"
    end
  end

end
