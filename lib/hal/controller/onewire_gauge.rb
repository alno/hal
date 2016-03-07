require 'onewire'

class Hal::Controller::OnewireGauge < Hal::Controller::Base

  def start
    @client = Onewire.client
    @thread = Thread.new { run }
  end

  def stop
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
    puts "Updating gauge #{node.path} from #{options[:path].inspect} in #{Time.now}"

    if value = @client.read(options[:path])
      bus.publish node.path, value
    else
      puts "No value avaliable for #{node.path}"
    end
  rescue => e
    puts "Error updating #{node.path}: #{e.message}"
  end

end
