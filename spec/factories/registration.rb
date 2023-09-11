# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: "WasteCarriersEngine::Registration" do
    sequence :reg_identifier do |n|
      "CBDU#{n}"
    end

    tier { "UPPER" }

    addresses { [build(:address), build(:address)] }

    metaData { association :metaData }

    trait :expires_soon do
      metaData { association :metaData, status: :ACTIVE }
      expires_on { 2.months.from_now }
    end
  end
end
