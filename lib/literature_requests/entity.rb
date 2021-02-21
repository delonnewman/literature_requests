module LiteratureRequests
  class Entity < HashDelegator
    def self.[](attributes = EMPTY_HASH)
      new(attributes.transform_keys(&:to_sym))
    end

    def initialize(attributes = EMPTY_HASH)
      super(attributes)
    end
  end
end
