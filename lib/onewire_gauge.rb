require 'history'
require 'onewire'

class OnewireGauge

  attr_reader :id, :index, :name, :source, :history

  def initialize(id, index, name, source)
    @id, @index, @name, @source = id, index, name, source
    @history = History.new index
    @ow = Onewire.client

    @thread = Thread.new { run }
  end

  def terminate
    @thread.terminate
  end

  def path
    id
  end

  private

  def run
    loop do
      sleep(10 - Time.now.sec % 10)
      update_value
    end
  end

  def update_value
    puts "Updating gauge #{id.inspect} in #{Time.now}"

    if value = @ow.read(source)
      history.update value
    end
  end

end
