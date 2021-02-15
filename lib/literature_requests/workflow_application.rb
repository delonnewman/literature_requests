module LiteratureRequests
  class WorkflowApplication < Roda
    plugin :render, views: 'templates/workflow'
    plugin :all_verbs

    route do |r|
      r.root do
        view :index
      end

      r.get 'congregation' do
        view :congregation, locals: { listing: LR.congregation.listing }
      end
    end
  end
end
