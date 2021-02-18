# frozen_string_literal: true
module LiteratureRequests
  class WorkflowApplication < Roda
    plugin :render, views: 'templates/workflow'
    plugin :all_verbs
    plugin :sessions, secret: SecureRandom.base64(64)
    # TODO: learn about roda's csrf support

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
          key    = r.params['key']
          person = LR.congregation.person_by_access(access_id: access_id, key: key)
          publications = [
            ['Awake!', LR.publications.magazine_by(code: :g, year: 2021)],
            ['Watchtower (public edition)' , LR.publications.magazine_by(code: :wp, year: 2021)],
            ['Watchtower (study edition)' , LR.publications.magazine_by(code: :w, year: 2021)],
            ['Our Christian Life and Ministry Meeting Workbook', LR.publications.meeting_workbooks_by(year: 2021)]
          ]

          if person
            view :request, locals: { person: person, publications: publications, key: key, access_id: access_id }, layout: :request_layout
          else
            view :no_access, layout: :request_layout
          end
        end

        r.post 'item' do
          key    = r.params['key']
          person = LR.congregation.person_by_access(access_id: access_id, key: key)
          r.session['items'] ||= []
          r.session['items'] << { person_id: person.id, code: r.params['code'], name: r.params['name'] }

          pp r.params

          r.redirect "/request/#{access_id}?key=#{key}"
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
