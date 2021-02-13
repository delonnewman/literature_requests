require 'bundler/setup'
Bundler.require

module LiteratureRequests
  require_relative 'literature_requests/entity'
  require_relative 'literature_requests/person'
  require_relative 'literature_requests/group'
  require_relative 'literature_requests/request'

  EMPTY_ARRAY = [].freeze
end
