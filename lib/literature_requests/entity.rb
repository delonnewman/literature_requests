module LiteratureRequests
  class Entity < HashDelegator
    transform_keys(&:to_sym)

    def self.[](attributes = EMPTY_HASH)
      new(attributes)
    end
  end
end
