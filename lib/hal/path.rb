class Hal::Path

  attr_reader :segments

  # Create path from sequence of path segments
  def self.[](*args)
    absolute, segments = collect_segments(*args)

    new(segments, absolute)
  end

  def self.root
    @root ||= self['/']
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

  def initialize(segments, absolute=false)
    @segments = segments.map(&:freeze).freeze
    @absolute = absolute
  end

  def absolute?
    @absolute
  end

  def relative?
    !absolute?
  end

  def /(other)
    self.class[self, other]
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
