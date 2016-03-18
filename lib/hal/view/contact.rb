class Hal::View::Contact < Hal::View::Base

  def switch_on
    send_command '1'
  end

  def switch_off
    send_command '0'
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
    s = DB[:state_changes].where('node = ?', node.path).select(:time, :value).order(:time).last
    s ||= {value: nil, time: Time.at(0)}
    s[:value] = MultiJson.decode(s[:value])
    s
  end

end