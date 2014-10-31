module Hal
  class Group

    attr_reader :children

    def initialize
      @children = {}
    end

    def terminate
      @children.each do |_,c|
        c.terminate if c.respond_to? :terminate
      end
    end

    def find(key)
      key.split('/').inject(self) { |c, name| c.children[name] }
    end

    private

    def create_child(name, child_class, *child_args)
      raise StandardError, "Child #{name.inspect} already exists!" if @children[name]

      @children[name] = child_class.new(*child_args)
    end

  end
end
