class Hal::View::Group < Hal::View::Base

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

end
