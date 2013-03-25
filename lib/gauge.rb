require 'config'
require 'database'

class Gauge < Struct.new(:id, :index, :name, :source)

  def self.all
    @gauges ||= APP_CONFIG['gauges'].map { |id, data|
      self.new id, data['index'], data['name'], data['source']
    }
  end

  def self.each(&block)
    all.each(&block)
  end

  def self.find(id)
    all.find { |g| g.id == id }
  end

  def update(val)
    DB[:gauge_values].insert gauge: index, time: Time.now, value: val
  end

  def values
    DB[:gauge_values].where(gauge: index)
  end

end
