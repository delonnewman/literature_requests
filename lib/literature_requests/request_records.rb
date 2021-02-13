module LiteratureRequests
  class RequestRecords < Repository
    LOAD_REQUEST_QUERY = <<~SQL

    SQL

    def initialize
      super(LiteratureRequests.db[:request_items], Request::Item)
    end

    def request_by_id(id)

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
