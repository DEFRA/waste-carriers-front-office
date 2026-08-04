# frozen_string_literal: true

# This class exists so Mongoid can instantiate documents written by the back
# office to the shared transient_registrations collection when the front office
# queries the base class (for example, during GovPay webhook payment lookups).
class CeasedOrRevokedRegistration < WasteCarriersEngine::TransientRegistration
end
