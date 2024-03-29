# frozen_string_literal: true

FactoryBot.define do
  factory :metaData, class: "WasteCarriersEngine::MetaData" do
    date_registered { Time.current }
    date_activated { Time.current }
  end
end
