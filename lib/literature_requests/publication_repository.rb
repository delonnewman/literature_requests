module LiteratureRequests
  class PublicationRepository < Repository
    def initialize
      super(LR.db[:publications], Publication)
    end

    def magazine_by(code:, year:, lang: 'E')
      codes = LR.magazines(code: code, year: year, lang: lang).map(&:code)
      @dataset.where(code: codes).map { |attrs| Publication[attrs] }
    end

    def meeting_workbooks_by(year:, lang: 'E')
      codes = LR.meeting_workbooks(year: year, lang: lang).map(&:code)
      @dataset.where(code: codes).map { |attrs| Publication[attrs] }
    end

    def store!(publication)
      @dataset.insert(publication.to_hash)
    end

    def store_all!(publications)
      records = publications.map(&:to_hash)
      @dataset.multi_insert(records)
    end
  end
end
