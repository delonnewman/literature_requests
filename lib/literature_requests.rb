require 'logger'
require 'yaml'
require 'securerandom'

require 'bundler/setup'
Bundler.require

module LiteratureRequests
  # Utils
  require_relative 'literature_requests/predicate_string'
  require_relative 'literature_requests/utils'

  # Entities
  require_relative 'literature_requests/entity'
  require_relative 'literature_requests/person'
  require_relative 'literature_requests/group'
  require_relative 'literature_requests/request'

  # Repositories
  require_relative 'literature_requests/repository'
  require_relative 'literature_requests/request_records'
  require_relative 'literature_requests/congregation'

  # Factories
  require_relative 'literature_requests/factory_methods'

  # Views
  require_relative 'literature_requests/congregation_listing'

  EMPTY_ARRAY = [].freeze

  LR = self
end
