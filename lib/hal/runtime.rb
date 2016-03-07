class Hal::Runtime

  attr_reader :definition, :bus

  def initialize(definition)
    @definition = definition
    @bus = Hal::EventBus.new

    @controllers = Array.new
    @persistors = Array.new

    @definition.controllers.each do |n, c, o|
      if cls = Hal::Controller.resolve(n.type, c)
        @controllers << cls.new(@bus, n, o)
      end
    end

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
