class Hal::Persistor::Base < Hal::Agent

  def start
    subscribe '', :update
  end

  def stop
    unsubscribe '', :update
  end

  private

  def update(state)
  end
end
