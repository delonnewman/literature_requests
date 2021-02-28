require_relative 'lib/literature_requests'
require_relative 'lib/literature_requests/application'

run LiteratureRequests::Application.freeze.app
