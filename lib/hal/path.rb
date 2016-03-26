class Hal::Path

  attr_reader :segments

  def self.root
    @root ||= new('/')
  end

  def self.collect_segments(*args)
    args.each_with_object [nil, []] do |arg, res|
      arg = arg.to_s

      if res[0].nil?
        res[0] = arg.start_with? '/'
      elsif arg.start_with? '/'
        raise "Can't append absolute path"
      end

      segments = arg.split(%r{\/+}).reject(&:empty?)

      res[1].push(*segments)
    end
  end

  def initialize(*strs)
    @absolute, @segments = self.class.collect_segments(*strs)
    @segments = @segments.map(&:freeze).freeze
  end

  def absolute?
    @absolute
  end

  def relative?
    !absolute?
  end

  def /(other)
    self.class.new(self, other)
  end

  def to_s
    if @absolute
      '/' + @segments.join('/')
    else
      @segments.join('/')
    end
  end

  def ==(other)
    absolute? == other.absolute? && segments == other.segments
  end

  def hash
    @segments.hash
  end

  alias eql? ==

end
