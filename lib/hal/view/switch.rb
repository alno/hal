class Hal::View::Switch < Hal::View::Contact

  def switch_on
    send_command '1'
  end

  def switch_off
    send_command '0'
  end

end
