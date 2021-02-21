module LiteratureRequests
  class IntakeDashboard
    attr_reader :person, :requests, :access_id, :key

    def initialize(access_id, key)
      @access_id = access_id
      @key       = key
      @person    = LR.congregation.person_by_access(access_id: access_id, key: key)
      @requests  = LR.requests.incomplete_requests_by_person_id(person.id) if @person
    end

    def permit_access?
      !!@person
    end

    def show_requests?
      !@requests.empty?
    end

    def publications
      [
        ['Awake!', LR.publications.magazine_by(code: :g, year: 2021)],
        ['Watchtower (public edition)' , LR.publications.magazine_by(code: :wp, year: 2021)],
        ['Watchtower (study edition)' , LR.publications.magazine_by(code: :w, year: 2021)],
        ['Our Christian Life and Ministry Meeting Workbook', LR.publications.meeting_workbooks_by(year: 2021)]
      ]
    end
  end
end
