require 'database'

class Hal::Persistor::Switch < Hal::Persistor::Base

  def start
    bus.subscribe node.path, method(:update)
  end

  def stop
  end

  private

  def update(val)
    DB[:state_changes].insert node: node.path, time: Time.now, value: MultiJson.encode(val)
  end

end
