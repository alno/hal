require 'onewire'

class Hal::Packages::Onewire::GaugeController < Hal::Controller

  every 60, :update

  private

  def update
    puts "Updating gauge #{node.path} from #{options[:path].inspect} in #{Time.now}"

    if (value = Onewire.client.read(options[:path]))
      bus.publish node.path, value
    else
      puts "No value avaliable for #{node.path}"
    end
  rescue => e
    puts "Error updating #{node.path}: #{e.message}"
  end

end
