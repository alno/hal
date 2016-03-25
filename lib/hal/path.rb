class Hal::Path

  attr_reader :segments

  def self.collect_segments(*args)
    args.each_with_object [] do |arg, res|
      segments = arg.to_s.split %r{\/+}

      if !res.empty? && !segments.empty? && segments.first.empty?
        raise "Can't append absolute path"
      else
        res.push(*segments)
      end
    end
  end

  def initialize(*strs)
    @segments = self.class.collect_segments(*strs).map(&:freeze).freeze
  end

  def absolute?
    !@segments.empty? && @segments.first.empty?
  end

  def relative?
    !absolute?
  end

  def /(other)
    self.class.new(self, other)
  end

  def to_s
    @segments.join('/')
  end

  def ==(other)
    @segments == other.segments
  end

  def hash
    @segments.hash
  end

  alias eql? ==

end
