require 'onewire'

class Hal::OnewireGaugeController < Hal::Controller

  def start
    @client = Onewire.client
    @thread = Thread.new { run }
  end

  def terminate
    @thread.terminate
    @thread = nil
    @client = nil
  end

  private

  def run
    loop do
      sleep(60 - Time.now.sec % 60)
      update
    end
  end

  def update
    puts "Updating gauge #{options[:path].inspect} in #{Time.now}"

    bus.publish path, @client.read(options[:path])
  end

end
