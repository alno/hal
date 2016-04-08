class Hal::Persistor::Base < Hal::Agent

  subscribe '', :update

  private

  def update(state)
  end
end
