module Hal
  autoload :Util, 'hal/util'

  autoload :NodeTypes, 'hal/node_types'
  autoload :Definition, 'hal/definition'
  autoload :DefinitionBuilder, 'hal/definition_builder'
  autoload :EventBus, 'hal/event_bus'

  autoload :Controller, 'hal/controller'
  autoload :Persistor, 'hal/persistor'

  autoload :Runtime, 'hal/runtime'
  autoload :View, 'hal/view'

  autoload :Package, 'hal/package'
  autoload :Packages, 'hal/packages'

  def self.load_definition(file, packages = [])
    builder = DefinitionBuilder.new

    packages.each{ |p| builder.import_package p }

    builder.build do
      instance_eval File.read(file), file
    end
  end
end
