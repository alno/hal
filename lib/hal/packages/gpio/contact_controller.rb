class Hal::Packages::Gpio::ContactController < Hal::Controller

  every 0.5, :update

  private

  def update
    puts "Updating contact #{node.path} from #{options[:pin].inspect} in #{Time.now}"

    value = File.read("/sys/class/gpio/gpio#{options[:pin]}/value").to_i
    value = 1 - value if options[:invert]

    if value
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
