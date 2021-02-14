module LiteratureRequests
  class People < Repository
    def initialize
      super(LiteratureRequests.db[:people], Person)
    end

    def by_id(id)
      Person.new(@dataset.first(id: id))
    end

    def find_by_name(name)
      result = @dataset.first(name)
      return nil if result.nil?

      Person[result]
    end

    def store!(person)
      @dataset.insert(person.to_hash)
      true
    end

    def store_all!(people)
      @dataset.multi_insert(people.map(&:to_hash))
      true
    end
  end
end
