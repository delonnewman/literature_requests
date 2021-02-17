# frozen_string_literal: true
module LiteratureRequests
  class WorkflowApplication < Roda
    plugin :render, views: 'templates/workflow'
    plugin :all_verbs

    def request_path(person)
      "/request/#{person.access_id}?key=#{person.access_key}"
    end

    def request_link(person)
      %{<a href="#{request_path(person)}">Request Link</a>}
    end

    def request_link_mail(person)
      %{mailto:#{person.email}?subject=Literature%20Request%20Form&amp;body=#{request_path(person)}}
    end

    route do |r|
      r.root do
        view :index, locals: { listing: LR.congregation.listing }
      end

      r.on 'request' do
        r.is String do |access_id|
          person = LR.congregation.person_by_access(access_id: access_id, key: r.params['key'])

          if person
            view :request, locals: { person: person }, layout: :request_layout
          else
            view :no_access, layout: :request_layout
          end
        end
      end

      r.on 'congregation' do
        r.get do
          view :congregation, locals: { listing: LR.congregation.listing }
        end

        r.on 'access_key' do
          r.is Integer do |person_id|
            LR.access_keys.store!(LR.generate_access_key_for(person_id))
            r.redirect '/congregation'
          end
        end
      end
    end
  end
end
