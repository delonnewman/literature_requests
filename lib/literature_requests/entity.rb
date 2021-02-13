module LiteratureRequests
  class Entity < HashDelegator
    def self.[](attributes)
      new(attributes)
    end
  end
end
