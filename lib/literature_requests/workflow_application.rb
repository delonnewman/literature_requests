# frozen_string_literal: true
module LiteratureRequests
  class WorkflowApplication < Roda
    plugin :render, views: 'templates/workflow'
    plugin :all_verbs
    plugin :sessions, secret: 'PomGByg46ORpjO9mNEwHLN0L5dm55KAMJSuc7su63UIkhMMNqFC97aMA+Pfnsp2htHpv6p2jnPpHkd82vrhxrQ=='
    # TODO: learn about roda's csrf support

    def request_path(person)
      "/request/#{person.access_id}?key=#{person.access_key}"
    end

    def request_link(person)
      %{<a href="#{request_path(person)}">View Request Form</a>}
    end

    def request_link_mail(person)
      %{mailto:#{person.email}?subject=Literature%20Request%20Form&amp;body=#{request_path(person)}}
    end

    def time_ago_in_words(time)
      time
    end

    def symbolize_keys(hash)
      return EMPTY_HASH if hash.nil?

      hash.reduce({}) do |h, (key, value)|
        case value
        when Hash
          h.merge!(key.to_sym => symbolize_keys(value))
        when Enumerable
          h.merge!(key.to_sym => value.map(&method(:symbolize_keys)))
        else
          h.merge!(key.to_sym => value)
        end
      end
    end

    route do |r|
      r.root do
        pending_publications = LR.requests.publications_by_status(:pending)
        view :index, locals: {
          statuses: LR.request_item_statuses,
          new_requests: LR.requests.by_status(:new),
          pending_publications: pending_publications
        }
      end

      r.get 'items' do
        fields = {
          person_name: 'Requester',
          publication_name: 'Publication Name',
          publication_code: 'Publication Code',
          quantity: 'Quantity',
          status: 'Status'
        }

        view :items, locals: { fields: fields, items: LR.requests.request_items } # TODO: Add pagination
      end

      r.on 'request' do
        @items = r.session.fetch('items') { EMPTY_ARRAY }.group_by { |i| i['code'] }.values

        r.post 'submission' do
          LR.requests.store_request!(Request[symbolize_keys(r.params['request'])])
          r.session['items'] = []

          access_id, key = r.params.values_at('access_id', 'key')
          r.redirect "/request/#{access_id}?key=#{key}"
        end

        r.post 'status' do
          request = LR.requests.by_id(r.params['request_id'])
          LR.requests.update_status!(request.id, r.params['status_code']) if request

          r.redirect "/"
        end

        r.post 'item' do
          puts "Posting item #{r.params}"

          r.session['items'] ||= []
          r.session['items'] << r.params.slice('person_id', 'code', 'name')

          access_id, key = r.params.values_at('access_id', 'key')

          r.redirect "/request/#{access_id}?key=#{key}"
        end

        r.is String do |access_id|
          dashboard = LR.intake_dashboard(access_id: access_id, key: r.params['key'])

          if dashboard.person
            view :request, locals: { dashboard: dashboard, items: @items }, layout: :request_layout
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
