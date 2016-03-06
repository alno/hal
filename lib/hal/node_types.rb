module Hal::NodeTypes
  TYPES = %i(group switch gauge camera)

  TYPES.each do |type|
    autoload Hal::Util.camelize(type).to_sym, "hal/#{type}_node_type"
  end

  def [](type)
    nil
  end
end
