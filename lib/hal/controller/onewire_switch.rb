require 'onewire'

class Hal::Controller::OnewireSwitch < Hal::Controller::Base

  def start
    @client = Onewire.client

    bus.subscribe(Hal::Util.join(node.path, :commands), method(:handle_command))
  end

  def terminate
    bus.unsubscribe(Hal::Util.join(node.path, :commands), method(:handle_command))

    @client = nil
  end

  private

  def handle_command(cmd)
    puts "Sending command #{cmd.inspect} to onewire #{options[:path]}"

    @client.write(options[:path], cmd)
  rescue => e
    puts "Error writing to #{options[:path]}: #{e.message}"
  end

end
