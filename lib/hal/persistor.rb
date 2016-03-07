module Hal::Persistor
  autoload :Base, 'hal/persistor/base'
  autoload :Gauge, 'hal/persistor/gauge'

  def self.resolve(type, persistor)
    case type
    when :gauge then Gauge
    else nil
    end
  end
end
