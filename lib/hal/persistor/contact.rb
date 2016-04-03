require 'database'

class Hal::Persistor::Contact < Hal::Persistor::Base

  private

  def update(val)
    DB[:state_changes].insert node: node.path.to_s, time: Time.now, value: MultiJson.encode(val)
  end

end
