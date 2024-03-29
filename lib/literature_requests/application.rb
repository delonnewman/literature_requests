# frozen_string_literal: true
module LiteratureRequests
  class Application < Roda
    include ApplicationHelpers

    plugin :render, views: 'templates/workflow'
    plugin :sessions, secret: 'PomGByg46ORpjO9mNEwHLN0L5dm55KAMJSuc7su63UIkhMMNqFC97aMA+Pfnsp2htHpv6p2jnPpHkd82vrhxrQ=='
    # TODO: learn about roda's csrf support

    route do |r|
      r.root do
        authenticate! r do
          view :index, locals: {
            statuses: LR.request_item_statuses,
            new_requests: LR.requests.by_status(:new),
            pending_publications: LR.requests.publications_by_status(:pending),
            received_items: LR.requests.people_with_items_by_status(:received)
          }
        end
      end

      r.post 'items/status' do
        authenticate! r do
          LR.requests.update_status_by_item!(r.params['status'], r.params['item_ids'])

          r.redirect "/"
        end
      end

      r.get 'items' do
        authenticate! r do
          fields = {
            person_name: 'Requester',
            publication_name: 'Publication Name',
            publication_code: 'Publication Code',
            quantity: 'Quantity',
            status: 'Status'
          }
  
          view :items, locals: { fields: fields, items: LR.requests.request_items } # TODO: Add pagination
        end
      end

      r.on 'request' do
        @items = r.session.fetch('items') { EMPTY_ARRAY }.group_by { |i| i['code'] }.values

        r.post 'submission' do
          LR.requests.store_request!(Request[symbolize_keys(r.params['request'])])
          r.session.delete('items')

          access_id, key = r.params.values_at('access_id', 'key')
          r.redirect "/request/#{access_id}?key=#{key}"
        end

        r.post 'status' do
          LR.requests.update_status!(r.params['status_code'], r.params['request_id'])

          r.redirect "/"
        end

        r.post 'item' do
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
          authenticate! r do
            view :congregation, locals: { listing: LR.congregation.listing }
          end
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
