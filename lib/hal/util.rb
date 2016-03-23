module Hal::Util
  module_function

  def camelize(s)
    s.to_s.gsub(/(\A|_)\w/, &:upcase)
  end

  def join(*args)
    args.reject { |a| a.nil? || a.empty? }.join('/')
  end

end
