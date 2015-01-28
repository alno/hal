module Hal
  class Group

    attr_reader :children

    def initialize(&block)
      @children = {}
      instance_eval(&block) if block_given?
    end

    def terminate
      @children.each do |_,c|
        c.terminate if c.respond_to? :terminate
      end
    end

    def find(path)
      return self if path.nil?

      path = path[1..-1] if path.start_with? '/'

      return self if path.empty?

      path.split('/').inject(self) { |c, name| c.children[name] }
    end

    def each_descendant_with_path(prefix = nil, &block)
      children.each do |name, child|
        path = prefix ? "#{prefix}/#{name}" : name

        yield child, path

        child.each_descendant_with_path path, &block if child.respond_to? :each_descendant_with_path
      end
    end

    def descendants_by_paths(prefix = nil)
      Hash.new.tap do |h|
        each_descendant_with_path do |desc, path|
          abspath = prefix ? "#{prefix}/#{path}" : path
          h[abspath] = desc
        end
      end
    end

    private

    def create_child(name, child_class, *child_args, &block)
      name = name.to_s

      raise StandardError, "Child #{name.inspect} already exists!" if @children[name]

      @children[name] = child_class.new(*child_args, &block)
    end

  end
end
