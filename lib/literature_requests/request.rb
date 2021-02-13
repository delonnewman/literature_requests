module LiteratureRequests
  class Request < Entity
    require :items, :requester

    def self.[](attributes)
      items = attributes.fetch(:items) { EMPTY_ARRAY }
      new(attributes
          .slice(:requester)
          .merge(items: items.map { |attrs| Item.new(attrs) }))
    end

    class Item < Entity
      require :literature_code

      STATUSES = {
        new:      0,
        pending:  1,
        recieved: 2
      }.freeze

      STATUS_CODES = STATUSES.map(&:reverse).to_h.freeze

      # generate predicate methods for each status
      STATUSES.keys.each do |status|
        define_method :"#{status}?" do
          self.status == status
        end
      end

      DEFAULT_ATTRIBUTES = {
        status_code: 0
      }.freeze

      def initialize(attributes)
        super(evaluated_attributes(attributes))
      end

      def status
        @hash.fetch(:status) { STATUS_CODES[status_code] }
      end

      def status_code
        @hash.fetch(:status_code) { STATUSES[status] }
      end

      private

      def evaluated_attributes(attributes)
        if not attributes.key?(:status) || attributes.key?(:status_code)
          DEFAULT_ATTRIBUTES.merge(attributes)
        elsif attributes.key?(:status)
          code = STATUSES[attributes[:status]]
          attributes.merge(status_code: code).tap do |h|
            h.delete(:status)
          end
        else
          attributes
        end
      end
    end
  end
end
