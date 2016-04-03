require 'database'

class Hal::Persistor::Gauge < Hal::Persistor::Base

  private

  def update(val)
    DB[:gauge_values].insert gauge: node.path.to_s, time: Time.now, value: val
  end

end
