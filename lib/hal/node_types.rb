module Hal
  module NodeTypes
    TYPES = %i(group switch gauge camera)

    TYPES.each do |type|
      autoload type.to_s.gsub(/(\A|_)\w/) { |m| m.upcase }.to_sym, "hal/node_types/#{type}"
    end

    def [](type)
      nil
    end
  end
end
