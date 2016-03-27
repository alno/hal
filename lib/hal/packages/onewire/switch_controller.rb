require 'onewire'

class Hal::Packages::Onewire::SwitchController < Hal::Controller

  def start
    @value = nil
    @client = Onewire.client
    @thread = Thread.new { run }

    bus.subscribe(node.path / :commands, method(:handle_command))
  end

  def terminate
    bus.unsubscribe(node.path / :commands, method(:handle_command))

    @thread.terminate
    @thread = nil
    @client = nil
    @value = nil
  end

  private

  def handle_command(cmd)
    puts "Sending command #{cmd.inspect} to onewire #{options[:path]}"

    @client.write(options[:path], cmd)
  rescue => e
    puts "Error writing to #{options[:path]}: #{e.message}"
  end

  def run
    loop do
      sleep(5 - Time.now.sec % 5)
      update
    end
  end

  def update
    puts "Updating switch #{node.path} from #{options[:path].inspect} in #{Time.now}"

    if (value = @client.read(options[:path]))
      if value == @value
        puts "Skipping the same value..."
      else
        bus.publish node.path, value
        @value = value
      end
    else
      puts "No value avaliable for #{node.path}"
    end
  rescue => e
    puts "Error updating #{node.path}: #{e.message}"
  end

end
