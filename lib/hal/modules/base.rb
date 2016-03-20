Hal::Controller.define :onewire do |node, options|
  case node.type
  when :gauge then Hal::Controller::OnewireGauge
  when :switch then Hal::Controller::OnewireSwitch
  else raise StandardError, "Onewire controller supports only gauge and switch nodes, #{node.type} given"
  end
end

Hal::Controller.define :gpio do |node, options|
  case node.type
  when :contact then Hal::Controller::GpioContact
  else raise StandardError, "Gpio controller supports only contact nodes, #{node.type} given"
  end
end

Hal::Controller.define :motion do |node, options|
  case node.type
  when :camera then Hal::Controller::MotionCamera
  else raise StandardError, "Motion controller supports only camera nodes, #{node.type} given"
  end
end
