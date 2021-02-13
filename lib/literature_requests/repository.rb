module LiteratureRequests
  class Repository
    include Enumerable

    def initialize(dataset)
      @dataset
    end

    def each(&block)
      @dataset.each(&block)
      self
    end
  end
end
