# frozen_string_literal: true
module LiteratureRequests
  class Congregation < Repository
    LISTING_QUERY = <<~SQL
        select publisher.first_name,
               publisher.last_name,
               overseer.first_name  || ' ' || overseer.last_name  as group_overseer
          from congregation publisher
     left join congregation overseer on publisher.group_overseer_id = overseer.id 
    SQL

    def initialize
      super(LiteratureRequests.db[:congregation].order(:last_name, :first_name), Person)
    end

    def listing
      CongregationListing.new(@dataset.db.fetch(LISTING_QUERY).to_a)
    end

    def by_id(id)
      result = @dataset.first(id: id)
      return nil if result.nil?

      Person[result]
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
    end

    def upsert!(person)
      result = @dataset.first(person.to_hash.slice(:first_name, :last_name))
      store!(person) if result.nil?

      result.update(person.to_hash) unless result.nil?
    end

    def upsert_all!(people)
      people.each(&method(:upsert!))
      people.count
    end

    def remove_by_id(id)
      @dataset.where(id: id).delete
    end
  end
end
