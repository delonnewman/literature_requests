module LiteratureRequests
  class IntakeApplication < Roda
    plugin :render, views: 'templates/intake', escape: true
    plugin :all_verbs

    route do |r|
      r.root do
        view :index
      end
    end
  end
end
