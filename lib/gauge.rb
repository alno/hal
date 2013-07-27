require 'config'
require 'database'

Gauge = Struct.new :id, :index, :name, :source do

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

  def values_table(from = nil, to = nil)
    if from.nil? || to.nil?
      :gauge_value_hours
    elsif to.to_i - from.to_i < 10 * 24 * 60 * 1000 # Less than 10 days - by minute
      :gauge_values
    elsif to.to_i - from.to_i < 600 * 24 * 60 * 1000 # Less than 600 days - by hour
      :gauge_value_hours
    else
      :gauge_value_days
    end
  end

  def values(from = nil, to = nil)
    from ||= DB[:gauge_values].min(:time)
    to   ||= DB[:gauge_values].max(:time)
    DB[values_table(from, to)].where('gauge = ? AND time BETWEEN ? AND ?', index, from, to)
  end

  def values_as_json(from = nil, to = nil)
    values(from, to).select(:time, :value).map{|r| [r[:time].to_i * 1000, r[:value]]}
  end

end
