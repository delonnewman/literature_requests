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

    def run(query, *args, factory: nil, &block)
      results = @dataset.db.fetch(query, *args).map do |row|
        row = row.transform_keys(&:to_sym)
        if factory
          factory[row]
        else
          row
        end
      end

      return EMPTY_ARRAY if results.empty?

      if block
        block.call(results)
      else
        results
      end
    end
  end
end
