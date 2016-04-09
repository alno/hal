require 'timers'

class Hal::Agent

  class << self

    def subscriptions
      @subscriptions ||= {}
    end

    def subscribe(path, method_name)
      subscriptions[path.to_s] = method_name
    end

    def every(seconds, method_name)
      timers << [seconds, method_name]
    end

    def timers
      @timers ||= []
    end

  end

  attr_reader :bus, :node, :options

  def initialize(bus, node, options)
    @bus = bus
    @node = node
    @options = options
  end

  def start
    raise StandardError, "Already started" if @thread

    @timers = create_timers

    # Start timers
    self.class.timers.each { |p, m| @timers.every(p) { send(m) } }

    # Start subscriptions
    self.class.subscriptions.each { |p, m| subscribe(p, m) }

    # Start thread
    @thread = create_thread
  end

  def stop
    raise StandardError, "Not started" unless @thread

    self.class.subscriptions.each { |p, m| unsubscribe(p, m) }

    @thread.terminate
    @thread = nil
    @timers = nil
  end

  private

  def create_timers
    Timers::Group.new
  end

  def create_thread
    Thread.new { run }
  end

  def run
    loop do
      begin
        @timers.wait
      rescue => e
        puts e.backtrace.inspect
      end
    end
  end

  def subscribe(path, method_name)
    bus.subscribe(expand_path(path), method(method_name))
  end

  def unsubscribe(path, method_name)
    bus.unsubscribe(expand_path(path), method(method_name))
  end

  def expand_path(path)
    path = Hal::Path[path]

    if path.absolute?
      path
    else
      node.path / path
    end
  end
end
