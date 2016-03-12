class Hal::View::Switch < Hal::View::Base

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
    DB[:state_changes].where('node = ?', node.path).select(:time, :value).order(:time).last
  end

end
