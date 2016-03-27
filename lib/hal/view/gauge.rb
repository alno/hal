require 'database'

class Hal::View::Gauge < Hal::View::Base

  def values(from = nil, to = nil)
    from ||= DB[:gauge_values].where('gauge = ?', node.path.to_s).min(:time)
    to   ||= Time.now

    DB[values_table(from, to)].where('gauge = ? AND time BETWEEN ? AND ?', node.path.to_s, from, to)
  end

  def values_as_json(from = nil, to = nil)
    values(from, to).select(:time, :value).map { |r| [r[:time].to_i * 1000, r[:value]] }
  end

  def as_json
    super.merge(last_known_state)
  end

  def value
    last_known_state[:value]
  end

  private

  # Get last known gauge value
  def last_known_state
    s = DB[:gauge_values].where('gauge = ?', node.path.to_s).select(:time, :value).order(:time).last
    s ||= { value: nil, time: Time.at(0) }
    s
  end

  SECONDS_IN_DAY = 24 * 60 * 60

  def values_table(from = nil, to = nil)
    if from.nil? || to.nil?
      :gauge_value_hours
    elsif to.to_i - from.to_i < 10 * SECONDS_IN_DAY # Less than 10 days - by minute
      :gauge_values
    elsif to.to_i - from.to_i < 600 * SECONDS_IN_DAY # Less than 600 days - by hour
      :gauge_value_hours
    else
      :gauge_value_days
    end
  end

end
