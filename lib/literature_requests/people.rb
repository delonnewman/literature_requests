module LiteratureRequests
  class People < Repository
    def initialize
      super(LiteratureRequests.db[:people], Person)
    end

    def by_id(id)
      Person.new(@dataset.first(id: id))
    end

    def store!(person)
      @dataset.insert(person.to_hash)
      true
    end
  end
end
