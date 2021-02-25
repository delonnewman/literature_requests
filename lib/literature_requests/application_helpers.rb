# frozen_string_literal: true
module LiteratureRequests
  module ApplicationHelpers
    def request_path(person)
      "/request/#{person.access_id}?key=#{person.access_key}"
    end

    def request_link(person)
      %{<a href="#{request_path(person)}">View Request Form</a>}
    end

    def request_link_mail(person)
      %{mailto:#{person.email}?subject=Literature%20Request%20Form&amp;body=#{request_path(person)}}
    end

    def pluralize(number, string)
      if number == 1
        "#{number} #{string}"
      else
        "#{number} #{Inflection.plural string}"
      end
    end

    YEAR_IN_SECONDS  = 31104000
    MONTH_IN_SECONDS = 2592000
    WEEK_IN_SECONDS  = 604800
    DAY_IN_SECONDS   = 86400
    HOUR_IN_SECONDS  = 3600

    def time_ago_in_words(time)
      diff   = Time.now - time
      suffix = diff < 0 ? 'from now' : 'ago'
      diff_  = diff.abs

      if diff_ > YEAR_IN_SECONDS
        "#{pluralize (diff_ / YEAR_IN_SECONDS).floor, 'year'} #{suffix}"
      elsif diff_ > MONTH_IN_SECONDS
        "#{pluralize (diff_ / MONTH_IN_SECONDS).floor, 'month'} #{suffix}"
      elsif diff_ > WEEK_IN_SECONDS
        "#{pluralize (diff_ / WEEK_IN_SECONDS).floor, 'week'} #{suffix}"
      elsif diff_ > DAY_IN_SECONDS
        "#{pluralize (diff_ / DAY_IN_SECONDS).floor, 'day'} #{suffix}"
      elsif diff_ > HOUR_IN_SECONDS
        "#{pluralize (diff_ / HOUR_IN_SECONDS).floor, 'hour'} #{suffix}"
      elsif diff_ > 60
        "#{pluralize (diff_ / 60).floor, 'minute'} #{suffix}"
      else
        'just now'
      end
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

    def current_user
      @current_user
    end

    def authenticate!(r, &block)
      return block.call(@current_user) if @current_user

      access_id, access_key = r.session.values_at('access_id', 'key')
      access_id, access_key = r.params.values_at('access_id', 'key') unless access_id && access_key
      
      if access_id && access_key
        @current_user = LR.congregation.person_by_access(access_id: access_id, key: access_key)
        r.session['access_id'] = access_id
        r.session['key'] = access_key
      end

      if @current_user.nil? || !@current_user.admin?
        r.response.status = 403
        'Unauthorized'
      else
        block.call(@current_user)
      end
    end
  end
end
