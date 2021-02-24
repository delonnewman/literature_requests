module LiteratureRequests
  class Entity < HashDelegator
    def self.[](attributes = EMPTY_HASH)
      new(attributes.transform_keys(&:to_sym))
    end

    def initialize(attributes = EMPTY_HASH)
      super(attributes)
    end

    def hash
      @hash.hash
    end

    def eql?(other)
      @hash.hash == other.hash
    end

    def ==(other)
      other.is_a?(self.class) && @hash.hash == other.hash
    end

    def ===(other)
      @hash.hash == other.hash
    end
  end
end
