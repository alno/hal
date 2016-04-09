require 'onewire'

class Hal::Packages::Onewire::SwitchController < Hal::Controller

  every 5, :update
  subscribe :commands, :handle_command

  private

  def handle_command(cmd)
    puts "Sending command #{cmd.inspect} to onewire #{options[:path]}"

    Onewire.client.write(options[:path], cmd)
  rescue => e
    puts "Error writing to #{options[:path]}: #{e.message}"
  end

  def update
    puts "Updating switch #{node.path} from #{options[:path].inspect} in #{Time.now}"

    if (value = Onewire.client.read(options[:path]))
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
