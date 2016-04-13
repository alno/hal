require 'onewire'

class Hal::Packages::Onewire::GaugeController < Hal::Controller

  every 60, :update

  private

  def update
    Hal.logger.debug "Updating gauge #{node.path} from #{options[:path].inspect} in #{Time.now}"

    if (value = Onewire.client.read(options[:path]))
      bus.publish node.path, value
    else
      Hal.logger.debug "No value avaliable for #{node.path}"
    end
  rescue => e
    Hal.logger.error "Error updating #{node.path}: #{e.message}"
  end

end
