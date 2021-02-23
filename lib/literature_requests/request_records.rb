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

    REQUEST_ITEMS_QUERY = <<~SQL
      select person.id as person_id,
             person.first_name || ' ' || person.last_name as person_name,
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
    order by item.status_code, item.request_id, person.last_name, person.first_name
    SQL

    REQUESTS_BY_STATUS_QUERY = <<~SQL
      select person.id,
             person.first_name,
             person.last_name,
             overseer.first_name || ' ' || overseer.last_name as group_overseer,
             item.request_id,
             item.status_code,
             item.publication_code,
             pubs.name as publication_name,
             item.quantity,
             item.created_at,
             item.updated_at
        from congregation person
   left join congregation overseer on person.group_overseer_id = overseer.id
  inner join request_items item on person.id = item.requester_id
  inner join publications pubs on item.publication_code = pubs.code
       where item.status_code in (?)
    order by publication_code
    SQL

    REQUESTS_BY_ID_QUERY = <<~SQL
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
       where item.request_id in (?)
    SQL

    def initialize
      super(LiteratureRequests.db[:request_items], Request::Item)
    end

    def request_items
      run REQUEST_ITEMS_QUERY, factory: Request::Item
    end

    def by_id(request_id)
      run REQUESTS_BY_ID_QUERY, request_id do |results|
        request_from_results(request_id, results)
      end
    end

    def update_status!(request_id, status)
      status_code = Request.ensure_status_code(status)
      @dataset.where(request_id: request_id).update(status_code: status_code)
    end

    def publications_by_status(status)
      status_code = Request.ensure_status_code(status)
      run REQUESTS_BY_STATUS_QUERY, status_code do |results|
        results.group_by { |r| r.values_at(:publication_code, :publication_name) }.map do |(code, name), results|
          requesters = results.group_by { |r| r.slice(:id, :first_name, :last_name, :group_overseer) }.map do |person, results|
            items = results.map { |r| Request::Item[r.slice(:request_id, :status_code, :publication_code, :quantity, :created_at, :updated_at)] }
            Person[person.merge!(items: items)]
          end
          Publication[code: code, name: name, requesters: requesters]
        end
      end
    end

    def by_status(*statuses)
      run REQUESTS_BY_STATUS_QUERY, *Request.ensure_status_code(*statuses) do |results|
        results.group_by { |r| r[:request_id] }.map do |(request_id, results)|
          request_from_results(request_id, results)
        end
      end
    end

    def incomplete_requests_by_person_id(person_id)
      run REQUESTS_BY_PERSON_ID_QUERY, person_id do |results|
        results.group_by { |r| r[:request_id] }.map do |(request_id, results)|
          request_from_results(request_id, results)
        end
      end
    end

    def store_request!(request)
      items = request.items.map do |item|
        item.merge(
          requester_id: item.fetch(:requester) { request.requester.id },
          request_id: request.id
        )
      end

      @dataset.multi_insert(items)

      true
    end

    private

      def request_from_results(request_id, results)
        Request[
          id: request_id,
          requester: Person[results.first.slice(:id, :first_name, :last_name, :group_overseer)],
          items: results.map { |i| i.slice(:request_id, :status_code, :publication_code, :publication_name, :quantity, :created_at, :updated_at) }]
      end
  end
end
