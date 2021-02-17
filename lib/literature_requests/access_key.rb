module LiteratureRequests
  class AccessKey < Entity
    require :key, :person_id

    def id
      fetch(:id) { SecureRandom.uuid }
    end
  end
end
