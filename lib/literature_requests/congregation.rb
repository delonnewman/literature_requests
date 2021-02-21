# frozen_string_literal: true
module LiteratureRequests
  class Congregation < Repository
    LISTING_QUERY = <<~SQL
        select publisher.id,
               publisher.first_name,
               publisher.last_name,
               publisher.email,
               access_keys.id  as access_id,
               access_keys.key as access_key,
               overseer.first_name  || ' ' || overseer.last_name  as group_overseer
          from congregation publisher
     left join congregation overseer on publisher.group_overseer_id = overseer.id
     left join access_keys on publisher.id = access_keys.person_id
    SQL

    ACCESS_QUERY = <<~SQL
          select person.id,
                 person.first_name,
                 person.last_name,
                 person.email
            from congregation person
      inner join access_keys on person.id = access_keys.person_id
           where access_keys.id = ? and access_keys.key = ?
    SQL

    PERSON_ACCESS_QUERY = <<~SQL
          select person.id,
                 person.first_name,
                 person.last_name,
                 person.email,
                 access_keys.id as access_id,
                 access_keys.key as access_key
            from congregation person
      inner join access_keys on person.id = access_keys.person_id
           where person.id = ?
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

    def person_with_access_by_id(id)
      result = @dataset.db.fetch(PERSON_ACCESS_QUERY, id).first
      return nil if result.nil?

      Person[result]
    end

    def person_by_access(access_id:, key:)
      result = @dataset.db.fetch(ACCESS_QUERY, access_id, key).first
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
