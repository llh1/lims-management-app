require 'common'

module Lims
  module Core
    NO_AUTOLOAD = true
  end
end

require 'lims-management-app/version'
require 'lims-management-app/sample/all'

require 'lims-api/server'
require 'lims-api/context_service'
require 'lims-api/message_bus'

module Lims
  module ManagementApp

  end
end
