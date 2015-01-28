require 'hal/group'
require 'onewire_gauge'
require 'camera'

SYSTEM = Hal::Group.new 'HAL' do

  create_child :home, Hal::Group, 'Home' do
    create_child :room_temp,  OnewireGauge, :room_temp,  1, 'Room temperature',   '/10.67C6697351FF/temperature'
    create_child :floor_temp, OnewireGauge, :floor_temp, 2, 'Window temperature', '/28.E52260040000/temperature'

    create_child :degu_camera, Camera, 'degu', 1, 'Degu camera'
    create_child :door_camera, Camera, 'door', 2, 'Door camera'
    create_child :room_camera, Camera, 'room', 3, 'Room camera'
  end

end
