require 'common'
require 'lims-management-app/sample/component'

module Lims::ManagementApp
  class Sample
    class CellularMaterial
      include Virtus
      include Aequitas
      include Sample::Component
      attribute :lysed, Boolean, :required => false, :initializable => true
      attribute :extraction_process, String, :required => false, :initializable => true
      attribute :donor_id, String, :required => false, :initializable => true
    end
  end
end
