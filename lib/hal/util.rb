module Hal::Util
  module_function

  def camelize(s)
    s.to_s.gsub(/(\A|_)\w/, &:upcase)
  end

end
