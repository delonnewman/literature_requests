require_relative 'lib/literature_requests'
require_relative 'lib/literature_requests/intake_application'

run LiteratureRequests::IntakeApplication.freeze.app
