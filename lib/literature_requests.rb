require 'pp'
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
  require_relative 'literature_requests/access_key'
  require_relative 'literature_requests/publication'

  # Repositories
  require_relative 'literature_requests/repository'
  require_relative 'literature_requests/request_records'
  require_relative 'literature_requests/congregation'
  require_relative 'literature_requests/access_key_repository'
  require_relative 'literature_requests/publication_repository'

  # Models
  require_relative 'literature_requests/user'

  # Factories
  require_relative 'literature_requests/factory_methods'

  # Views
  require_relative 'literature_requests/congregation_listing'
  require_relative 'literature_requests/intake_dashboard'

  # Some helpful constants
  EMPTY_ARRAY = [].freeze
  EMPTY_HASH  = {}.freeze
  LR = self
end
