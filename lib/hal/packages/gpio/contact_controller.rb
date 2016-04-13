class Hal::Packages::Gpio::ContactController < Hal::Controller

  every 0.5, :update

  private

  def update
    Hal.logger.debug "Updating contact #{node.path} from #{options[:pin].inspect} in #{Time.now}"

    value = File.read("/sys/class/gpio/gpio#{options[:pin]}/value").to_i
    value = 1 - value if options[:invert]

    if value
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
