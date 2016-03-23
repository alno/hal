module Hal::NodeTypes
  TYPES = %i(group switch gauge camera contact).freeze

  TYPES.each do |type|
    autoload Hal::Util.camelize(type).to_sym, "hal/#{type}_node_type"
  end
end
