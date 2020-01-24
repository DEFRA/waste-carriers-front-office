# frozen_string_literal: true

module WasteCarriersEngine
  module JourneyLinksHelper
    def renewal_finished_link(*)
      main_app.fo_path
    end
  end
end
