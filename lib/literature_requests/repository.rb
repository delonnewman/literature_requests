module LiteratureRequests
  class Repository
    include Enumerable

    def initialize(dataset, factory)
      @dataset = dataset
      @factory = factory
    end

    def each(&block)
      @dataset.each do |row|
        block.call(@factory[row])
      end
      self
    end
  end
end
