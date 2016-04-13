require 'onewire'

class Hal::Packages::Onewire::SwitchController < Hal::Controller

  every 5, :update
  subscribe :commands, :handle_command

  private

  def handle_command(cmd)
    Hal.logger.debug "Sending command #{cmd.inspect} to onewire #{options[:path]}"

    Onewire.client.write(options[:path], cmd)
  rescue => e
    Hal.logger.error "Error writing to #{options[:path]}: #{e.message}"
  end

  def update
    Hal.logger.debug "Updating switch #{node.path} from #{options[:path].inspect} in #{Time.now}"

    if (value = Onewire.client.read(options[:path]))
      if value == @value
        Hal.logger.debug "Skipping the same value..."
      else
        bus.publish node.path, value
        @value = value
      end
    else
      Hal.logger.debug "No value avaliable for #{node.path}"
    end
  rescue => e
    Hal.logger.error "Error updating #{node.path}: #{e.message}"
  end

end
