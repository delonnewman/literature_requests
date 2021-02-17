module LiteratureRequests
  class AccessKeyRepository < Repository
    def initialize
      super(LR.db[:access_keys], AccessKey)
    end

    def store!(key)
      @dataset.insert(key.to_hash)
    end
  end
end
