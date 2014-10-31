require 'hal/group'
require 'onewire_gauge'

SYSTEM = Hal::Group.new.instance_eval do

  create_child 'room_temp',  OnewireGauge, :room_temp,  1, 'Room temperature',   '/10.67C6697351FF/temperature'
  create_child 'floor_temp', OnewireGauge, :floor_temp, 2, 'Window temperature', '/28.E52260040000/temperature'

  self

end
