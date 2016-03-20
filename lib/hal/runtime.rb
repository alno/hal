class Hal::Runtime

  attr_reader :definition, :bus, :controllers, :persistors

  def initialize(definition)
    @definition = definition
    @bus = Hal::EventBus.new

    @persistors = Array.new

    @controllers = @definition.controllers.map{ |n, c, o| c.new(@bus, n, o) }

    @definition.persistors.each do |n, p, o|
      if cls = Hal::Persistor.resolve(n.type, p)
        @persistors << cls.new(@bus, n, o)
      end
    end
  end

  def start
    @persistors.each(&:start)
    @controllers.each(&:start)
  end

  def stop
    @controllers.each(&:stop)
    @persistors.each(&:stop)
  end

end
