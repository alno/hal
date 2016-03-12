module Hal::Persistor
  autoload :Base, 'hal/persistor/base'
  autoload :Gauge, 'hal/persistor/gauge'
  autoload :Switch, 'hal/persistor/switch'

  def self.resolve(type, persistor)
    case type
    when :gauge then Gauge
    when :switch then Switch
    else nil
    end
  end
end
