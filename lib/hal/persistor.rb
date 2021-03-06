module Hal::Persistor
  autoload :Base, 'hal/persistor/base'
  autoload :Gauge, 'hal/persistor/gauge'
  autoload :Switch, 'hal/persistor/switch'
  autoload :Contact, 'hal/persistor/contact'

  def self.resolve(type, _persistor)
    case type
    when :gauge then Gauge
    when :switch then Switch
    when :contact then Contact
    end
  end
end
