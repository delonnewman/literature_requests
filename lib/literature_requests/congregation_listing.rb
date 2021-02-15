module LiteratureRequests
  class CongregationListing
    include Enumerable

    def initialize(records)
      @records = records
    end

    def groups
      group_by { |p| p.group_overseer || p.name }
        .values
        .map(&:sort)
        .map(&Group.method(:new))
    end
    
    def each(&block)
      @records.each do |record|
        block.call(Person[record])
      end
    end
  end
end
