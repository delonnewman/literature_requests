module LiteratureRequests
  class AccessKeyRepository < Repository
    def initialize
      super(LR.db[:access_keys], AccessKey)
    end

    def store!(key)
      @dataset.insert(key.to_hash)
      record = @dataset.first(key.to_hash)
      AccessKey[record] if record
    end
  end
end
