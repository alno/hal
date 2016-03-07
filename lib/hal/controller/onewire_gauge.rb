require 'onewire'

class Hal::Controller::OnewireGauge < Hal::Controller::Base

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

    bus.publish node.path, @client.read(options[:path])
  rescue => e
    puts "Error updating: #{e.message}"
  end

end
