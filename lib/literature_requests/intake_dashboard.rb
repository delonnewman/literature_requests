module LiteratureRequests
  # A presentation object for the request intake dashboard.
  # @attr_reader person [Person] - the person viewing the dashboard
  # @attr_reader requests [Request] - the pending requests for the person
  # @attr_reader access_id [String] - the UUID access id for the person
  # @attr_reader key [String] - the access key for the person
  class IntakeDashboard
    attr_reader :person, :requests, :access_id, :key

    def initialize(access_id, key)
      @access_id = access_id
      @key       = key
      @person    = LR.congregation.person_by_access(access_id: access_id, key: key)
      @requests  = LR.requests.incomplete_requests_by_person_id(person.id) if @person
    end

    # Return true if access should be permitted for the person, otherwise return false.
    def permit_access?
      !!@person
    end

    # Return true if the pending requests should be shown on the dashboard, otherwise return false.
    def show_requests?
      !@requests.empty?
    end

    # Return an array of arrays of publication names and corresponding publication objects.
    #
    # @return [Array<[String, Array<Publiction>]>]
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
