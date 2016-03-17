class Hal::Controller::GpioContact < Hal::Controller::Base

  def start
    @value = nil
    @thread = Thread.new { run }
  end

  def terminate
    @thread.terminate
    @thread = nil
    @value = nil
  end

  private

  def run
    loop do
      sleep(0.5)
      update
    end
  end

  def update
    puts "Updating contact #{node.path} from #{options[:pin].inspect} in #{Time.now}"

    if value = File.read("/sys/class/gpio/gpio#{options[:pin]}/value").to_i
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
