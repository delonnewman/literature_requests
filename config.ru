require_relative 'lib/literature_requests'
require_relative 'lib/literature_requests/workflow_application'

run LiteratureRequests::WorkflowApplication.freeze.app
