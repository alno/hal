require 'database'

class Hal::View::Gauge < Hal::View::Base

  def values(from = nil, to = nil)
    from ||= DB[:gauge_values].where('gauge = ?', node.path).min(:time)
    to   ||= Time.now

    DB[values_table(from, to)].where('gauge = ? AND time BETWEEN ? AND ?', node.path, from, to)
  end

  def values_as_json(from = nil, to = nil)
    values(from, to).select(:time, :value).map{|r| [r[:time].to_i * 1000, r[:value]]}
  end

  private

  def values_table(from = nil, to = nil)
    if from.nil? || to.nil?
      :gauge_value_hours
    elsif to.to_i - from.to_i < 10 * 24 * 60 * 60 # Less than 10 days - by minute
      :gauge_values
    elsif to.to_i - from.to_i < 600 * 24 * 60 * 60  # Less than 600 days - by hour
      :gauge_value_hours
    else
      :gauge_value_days
    end
  end

end
