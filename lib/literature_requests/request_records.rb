module LiteratureRequests
  class RequestRecords < Repository
    REQUESTS_BY_PERSON_ID_QUERY = <<~SQL
      select person.id,
             person.first_name,
             person.last_name,
             item.request_id,
             item.status_code,
             item.publication_code,
             pubs.name as publication_name,
             item.quantity,
             item.created_at,
             item.updated_at
        from congregation person
  inner join request_items item on person.id = item.requester_id
  inner join publications pubs on item.publication_code = pubs.code
       where person.id = ? and item.status_code != 3
    SQL

    REQUESTS_BY_STATUS_QUERY = <<~SQL
      select person.id,
             person.first_name,
             person.last_name,
             item.request_id,
             item.status_code,
             item.publication_code,
             pubs.name as publication_name,
             item.quantity,
             item.created_at,
             item.updated_at
        from congregation person
  inner join request_items item on person.id = item.requester_id
  inner join publications pubs on item.publication_code = pubs.code
       where item.status_code in (?)
    SQL
    def initialize
      super(LiteratureRequests.db[:request_items], Request::Item)
    end

    def by_status(*statuses)
      results = @dataset.db.fetch(REQUESTS_BY_STATUS_QUERY, Request.ensure_status_code(*statuses)).map { |row| row.transform_keys(&:to_sym) }
      pp results

      results.group_by { |r| r[:request_id] }.map do |(request_id, results)|
        Request[
          id: request_id,
          requester: Person[results.first.slice(:id, :first_name, :last_name)],
          items: results.map { |i| i.slice(:request_id, :status_code, :publication_code, :publication_name, :quantity, :created_at, :updated_at) }]
      end
    end

    def incomplete_requests_by_person_id(person_id)
      results = @dataset.db.fetch(REQUESTS_BY_PERSON_ID_QUERY, person_id).map { |row| row.transform_keys(&:to_sym) }
      return EMPTY_ARRAY if results.empty?

      requester = Person[results.first.slice(:id, :first_name, :last_name)]
      results.group_by { |r| r[:request_id] }.map do |(request_id, results)|
        Request[
          id: request_id,
          requester: requester,
          items: results.map { |i| i.slice(:request_id, :status_code, :publication_code, :publication_name, :quantity, :created_at, :updated_at) }]
      end
    end

    def store!(request)
      items = request.items.map do |item|
        item.merge(
          requester_id: item.fetch(:requester) { request.requester.id },
          request_id: request.id
        )
      end

      @dataset.multi_insert(items)
      true
    end
  end
end
